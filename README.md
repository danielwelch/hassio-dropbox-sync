# Hass.io Add-on: Dropbox Sync
Back up your Hass.io snapshots to Dropbox.

### About
This add-on allows you to upload your Hass.io snapshots to your Dropbox, keeping your snapshots safe and available in case of hardware failure. This add-on allows you to upload your snapshots directly from Hass.io rather than having to use e.g. Samba share or SSH to first retreive the snapshot files before uploading.

This add-on uses the [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader) bash script to upload files to Dropbox. It requires that you generate an access token via the Dropbox Web UI, which must be added to this add-on's configuration via the Hass.io UI (see below for further details).

### Installation
1. Add the add-ons repository to your Hass.io instance: `https://github.com/danielwelch/hassio-addons`
2. Install the Dropbox Sync add-on
3. Configure the add-on with your Dropbox OAuth Token and desired output directory (see configuration below)


### Usage
As of now, this add on simply uploads the Hass.io `/backup` directory to a specified path in your Dropbox. This target path is specified via the `output` option. Note that the entire backup directory is uploaded.

To upload the directory, simply start the add-on. This triggers the `dropbox_uploader.sh` script with the provided access token. Repeat this process whenever you create a new backup that you'd like to upload to Dropbox.


### Configuration

To access your personal Dropobox, this add-on (and the `Dropbox-Uploader` script more generally) requires an access token. Follow these steps to create an Access Token:
1. Go to `https://www.dropbox.com/developers/apps`
2. Click the "Create App" button
3. Follow the prompts to set permissions and choose a unique name for your "app" token.

Once you have created the token, copy it into this add-on's configuration under the `oauth_access_token` label. 

|Parameter|Required|Description|
|---------|--------|-----------|
|`oauth_access_token`|Yes|The "app" access token you generated above via the Dropbox UI.|
|`output`|Yes|The target directory in your Dropbox to which you want to upload. If left empty, defaults to `/`, which represents the top level of directory of your Dropbox.|

Example Configuration:
```json
{
  "oauth_access_token": "<YOUR_TOKEN>",
  "output": "/hasssio-backups/"
}
```


### Planned Features and Future of this Add-on
There are a couple of things about this add-on that I'd like to change moving forward:
- Currently, the add-on requires that the user manually starts the add-on to trigger a backup. I'd like to make this more of a "set it and forget it" solution, perhaps by running the script every X number of hours, as determined by add-on configuration. This would require the user to install and start the add-on once, rather than needing to trigger a backup. This is a top priority.
- Currently, only the entire backup directory can be uploaded to Dropbox. This seems like the most useful backup method to me, as space is presumably not at a premium, and all backups can be managed (deleted, etc.) through the Hass.io UI. However, others may want more control or may not want to upload the entire directory every time (only new backups?). Exposing more control over this behavior via configuration options would be nice.
