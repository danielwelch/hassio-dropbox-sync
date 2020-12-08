# Hass.io Add-on: Dropbox Sync
Back up your Hass.io snapshots to Dropbox.

### About
This add-on allows you to upload your Hass.io snapshots to your Dropbox, keeping your snapshots safe and available in case of hardware failure. Uploads are triggered via a service call, making it easy to automate periodic backups or trigger uploads to Dropbox via script as you would with any other Home Assistant service.

This add-on uses the [Dropbox-Uploader](https://github.com/andreafabrizi/Dropbox-Uploader) bash script to upload files to Dropbox. It requires that you generate an access token via the Dropbox Web UI, which must be added to this add-on's configuration via the Hass.io UI (see below for further details).

### Installation
1. Add the add-ons repository to your Hass.io instance: `https://github.com/danielwelch/hassio-addons`
2. Install the Dropbox Sync add-on
3. Configure the add-on with your Dropbox OAuth Token and desired output directory (see configuration below)

### Usage

Dropbox Sync uploads all snapshot files (specifically, all `.tar` files) in the Hass.io `/backup` directory to a specified path in your Dropbox. This target path is specified via the `output` option. Once the add-on is started, it is listening for service calls.

After the add-on is configured and started, trigger an upload by calling the `hassio.addon_stdin` service with the following service data:

```json
{"addon":"7be23ff5_dropbox_sync","input":{"command":"upload"}}
```

This triggers the `dropbox_uploader.sh` script with the provided access token. You can use Home Assistant automations or scripts to run uploads at certain time intervals, under certain conditions, etc.
Dropbox Sync will only upload new snapshots to the specified path, and will skip snapshots already in the target Dropbox path.

The `keep last` option allows the add-on to clean up the local backup directory, deleting the local copies of the snapshots after they have been uploaded to Dropbox. If `keep_last` is set to some integer `x`, only the latest `x` snapshots will be stored locally; all other (older) snapshots will be deleted from local storage. All snapshots are always uploaded to Dropbox, regardless of this option.

The `filetypes` option allows the add-on to upload arbitrary filetypes from the Hass.io `/share` directory to Dropbox. Set this option to a string of extensions seperated by `|` to upload matching files to Dropbox. For example, setting this option to `"jpg|png"` will upload all files in the `/share` folder ending in `.jpg` or `.png`. These files will be uploaded to the directory specified by the `output` option.

*Note*: The hash `7be23ff5` that is prepended to the `dropbox_sync` add-on slug above is required. [See below](#repository-slugs-in-hassio) for an explanation. 
### Configuration

To access your personal Dropobox, this add-on (and the `Dropbox-Uploader` script more generally) requires an access token. Follow these steps to create an Access Token:
 1) Open the following URL in your Browser, and log in using your account: https://www.dropbox.com/developers/apps
 2) Click on "Create App", then select "Choose an API: Scoped Access"
 3) "Choose the type of access you need: App folder"
 4) Enter the "App Name" that you prefer (e.g. MyUploader3173010022202), must be uniqe

 Now, click on the "Create App" button.

 5) Now the new configuration is opened, switch to tab "permissions" and check "files.metadata.read/write" and "files.content.read/write"
 Now, click on the "Submit" button.

 6) Now to tab "settings" and provide the following information:
 App key: <YOUR_APP_KEY>
 App secret: <YOUR_APP_SECRET>

Once you have created the application, visit the following URL, replacing <YOUR_APP_KEY> below.

`https://www.dropbox.com/oauth2/authorize?client_id=<YOUR_APP_KEY>&token_access_type=offline&response_type=code`

Once you have authorized the application, copy it into this add-on's configuration under the `oauth_access_token` label. 

|Parameter|Required|Description|
|---------|--------|-----------|
|`oauth_app_key`|Yes|The "app" key you generated.|
|`oauth_app_secret`|Yes|The "app" secret you generated.|
|`oauth_access_token`|Yes|The "app" access token you generated above via the Dropbox UI.|
|`output`|Yes|The target directory in your Dropbox to which you want to upload. If left empty, defaults to `/`, which represents the top level of directory of your Dropbox.|
|`keep_last`|No|If set, the number of snapshots to keep locally. If there are more than this number of snapshots stored locally, the older snapshots will be deleted from local storage after being uploaded to Dropbox. If not set, no snapshots are deleted from local storage.|
|`filetypes`|No|File extensions of files to upload from `/share` directory, seperated by <code>&#124;</code> (ex: `"jpg|png" or "png"`).|

Example Configuration:
```json
{
  "oauth_app_key": "<YOUR_APP_KEY>",
  "oauth_app_secret": "<YOUR_APP_SECRET>",
  "oauth_access_token": "<YOUR_TOKEN>",
  "output": "/hasssio-backups/"
}
```

### Suggestions and Issues
If you have suggestions or use-cases not covered by this add-on, please leave a comment on [the forum topic](https://community.home-assistant.io/t/hass-io-add-on-upload-hassio-snapshots-to-dropbox/). Otherwise, you may file an issue here. The flexibility of the service call and JSON service data means that this add-on could be expanded to include new features or options relatively easily.

----

#### Repository slugs in Hassio
Hass.io add-on service calls such as `start`, `stop`, and `stdin` require an add-on identifier in the form `{REPO_HASH}_{ADDON_SLUG}`. The repository identifier is generated by hashing the full URL of an installed repository. For example, the slug necessary to use this add-on at all is generated in Hass.io via the following code:
```python
import hashlib

key = "https://github.com/danielwelch/hassio-addons"
my_repo_id = hashlib.sha1(key.lower().encode()).hexdigest()[:8]
```

I'd like to at least improve the documentation surrounding this on homeassistant.io; ideally, I think the hash for each installed repository should be displayed in the service description for services that rely on it. This would make it easy for users to compose service calls from within Home Assisant.

