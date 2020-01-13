#!/bin/bash

CONFIG_PATH=/data/options.json

TOKEN=$(jq --raw-output ".oauth_access_token" $CONFIG_PATH)
OUTPUT_DIR=$(jq --raw-output ".output // empty" $CONFIG_PATH)
ADDITIONAL_BACKUP_DIRS=$(jq --raw-output ".additional_backup_dirs // empty" $CONFIG_PATH)
KEEP_LAST=$(jq --raw-output ".keep_last // empty" $CONFIG_PATH)
FILETYPES=$(jq --raw-output ".filetypes // empty" $CONFIG_PATH)

if [[ -z "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR="/"
fi

echo "[Info] Files will be uploaded to: ${OUTPUT_DIR}"

echo "[Info] Saving OAUTH_ACCESS_TOKEN to /etc/uploader.conf"
echo "OAUTH_ACCESS_TOKEN=${TOKEN}" >> /etc/uploader.conf

echo "[Config] OUTPUT_DIR=${OUTPUT_DIR}"
echo "[Config] ADDITIONAL_BACKUP_DIRS=${ADDITIONAL_BACKUP_DIRS}"
echo "[Config] KEEP_LAST=${KEEP_LAST}"
echo "[Config] FILETYPES=${FILETYPES}"

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
        if [[ "$ADDITIONAL_BACKUP_DIRS" ]]; then
            echo "[Info] additional_backup_dirs option is set to ${ADDITIONAL_BACKUP_DIRS}"
            export IFS="|"
            for backup_dir in ${ADDITIONAL_BACKUP_DIRS}; do
              echo "[Info] backing up ${backup_dir}"
              ./dropbox_uploader.sh -s -f /etc/uploader.conf upload /backup/${backup_dir} "${OUTPUT_DIR}/${backup_dir}"
            done
        fi
        if [[ "$KEEP_LAST" ]]; then
            echo "[Info] keep_last option is set, cleaning up files..."
            python3 /keep_last.py "$KEEP_LAST"
        fi
        if [[ "$FILETYPES" ]]; then
            echo "[Info] filetypes option is set, scanning share directory for files with extensions ${FILETYPES}"
            find /share -regextype posix-extended -regex "^.*\.(${FILETYPES})" -exec ./dropbox_uploader.sh -s -f /etc/uploader.conf upload {} "$OUTPUT_DIR" \;
        fi
        echo "[Info] Complete"
    else
        # received undefined command
        echo "[Error] Command not found: ${cmd}"
    fi
done
