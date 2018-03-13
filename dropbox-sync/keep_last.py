import argparse
import os

import requests
from dateutil.parser import parse
import pytz

BASE_URL = "http://hassio/"
HEADERS = {"X-HASSIO-KEY": os.environ.get("HASSIO_TOKEN")}


def main(number_to_keep):

    snapshot_info = requests.get(BASE_URL + "snapshots", headers=HEADERS)
    snapshot_info.raise_for_status()

    snapshots = snapshot_info.json()["data"]["snapshots"]
    for snapshot in snapshots:
        d = parse(snapshot["date"])
        if d.tzinfo is None or d.tzinfo.utcoffset(d) is None:
            print("Naive DateTime found for snapshot {}, setting to UTC...".
                  format(snapshot["slug"]))
            snapshot["date"] = d.replace(tzinfo=pytz.utc).isoformat()
    snapshots.sort(key=lambda item: parse(item["date"]), reverse=True)
    keepers = snapshots[:number_to_keep]
    stale_snapshots = [snap for snap in snapshots if snap not in keepers]

    for snapshot in stale_snapshots:
        # call hassio API deletion
        res = requests.post(
            BASE_URL + "snapshots/" + snapshot["slug"] + "/remove",
            headers=HEADERS)
        if res.ok:
            print("[Info] Deleted snapshot {}".format(snapshot["slug"]))
            continue
        else:
            # log an error
            print("[Error] Failed to delete snapshot {}: {}".format(
                snapshot["slug"], res.status_code))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Remove old hassio snapshots.')
    parser.add_argument('number', type=int, help='Number of snapshots to keep')
    args = parser.parse_args()
    main(args.number)
