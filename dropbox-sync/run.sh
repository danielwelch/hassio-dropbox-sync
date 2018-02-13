#!/bin/bash

CONFIG_PATH=/data/options.json

TOKEN=$(jq --raw-output ".oauth_access_token" $CONFIG_PATH)
OUTPUT_DIR=$(jq --raw-output ".output")

if [ -z $"OUTPUT" ]; then
    OUTPUT_DIR="/"
fi

echo "OAUTH_ACCESS_TOKEN=${TOKEN}" >> /etc/uploader.conf

curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o /dropbox_uploader.sh

./dropbox_uploader.sh -f /etc/uploader.conf upload /backup "$OUTPUT_DIR"

exit 0
