# Hass.io Add-on: Dropbox Sync
Back up your Hass.io snapshots to Dropbox.

### About
This add-on allows you to upload your Hass.io snapshots to your Dropbox, keeping your snapshots safe and available in case of hardware failure. This add-on allows you to upload your snapshots directly from Hass.io rather than having to use e.g. Samba share or SSH to first retreive the snapshot files before uploading.

This add-on uses the [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader) bash script to upload files to Dropbox.

### Installation
1. Add the add-ons repository to your Hass.io instance: `https://github.com/danielwelch/hassio-addons`
2. Install the Dropbox Sync add-on
3. Configure the add-on with your Dropbox OAuth Token and desired output directory
4. Run the add-on to trigger an upload to Dropbox.

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
