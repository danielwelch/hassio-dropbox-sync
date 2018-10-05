# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [1.3.0](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.1.2) - 2018-03-27
### Changed
- Updated for new role-based permissions in hass.io API calls.
## [1.2.0](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.1.2) - 2018-03-27
### Changed
- Added `filetypes` option. Set this option to string of file extensions seperated by `|` to upload files with matching extensions to dropbox from the hassio `/share` folder.
    - For example: setting this option to `"jpg|png"` will upload all files in the `/share` folder ending in `.jpg` or `.png`

## [1.1.2](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.1.2) - 2018-03-13
### Changed
- hotfix release: remove `keep_last` from options but keep in schema in `config.json`

## [1.1.1](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.1.1) - 2018-03-11
### Changed
- make the `keep_last` argument optional

## [1.1.0](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.1.0) - 2018-03-10
### Changed
- Added `keep_last` option which, if set, will delete older snapshot images from the local Hass.io instance beyond what this is set to. For example, if set to `2`, only the last 2 snapshots will be kept locally. All snapshots are always uploaded to dropbox.

## [1.0.0](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/v1.0.0) - 2018-02-18
### Changed
- Uploads are triggered via service calls to `hassio.addon_stdin`, allowing for automations and scripting of Dropbox uploads. Thanks @jchasey for the suggestion.
- Uploads all `.tar` files in the backup directory to a specified output path, skipping files that have already been uploaded (No longer uploads entire directory).
- Start the add-on once and leave it on. It will listen for messages via service calls, as detailed in the README.
  - Note: this means no upload is triggered when the add-on is started, only when a service call is made.

## [0.1.0](https://github.com/danielwelch/hassio-dropbox-sync/releases/tag/0.1.0) - 2018-02-13
