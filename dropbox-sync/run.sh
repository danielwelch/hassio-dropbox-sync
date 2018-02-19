#!/bin/bash

CONFIG_PATH=/data/options.json

TOKEN=$(jq --raw-output ".oauth_access_token" $CONFIG_PATH)
OUTPUT_DIR=$(jq --raw-output ".output" $CONFIG_PATH)

if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="/"
fi

echo "[Info] Files will be uploaded to: ${OUTPUT_DIR}"

echo "[Info] Saving OAUTH_ACCESS_TOKEN to /etc/uploader.conf"
echo "OAUTH_ACCESS_TOKEN=${TOKEN}" >> /etc/uploader.conf

echo "[Info] Listening for messages via stdin service call..."

# listen for input
while read -r msg; do
    # parse JSON
    echo "$msg"
    cmd="$(echo "$msg" | jq --raw-output '.command')"
    echo "[Info] Received message with command ${cmd}"
    if [[ $cmd = "upload" ]]; then
        echo "[Info] Uploading all .tar files in /backup (skipping those already in Dropbox)"
        ./dropbox_uploader.sh -s -f /etc/uploader.conf upload /backup/*.tar "$OUTPUT_DIR"
    else
        # received undefined command
        echo "[Error] Command not found: ${cmd}"
    fi
done
