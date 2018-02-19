# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2018-02-18
### Changed
- Uploads are triggered via service calls to `hassio.addon_stdin`, allowing for automations and scripting of Dropbox uploads. Thanks @jchasey for the suggestion.
- Uploads all `.tar` files in the backup directory to a specified output path, skipping files that have already been uploaded (No longer uploads entire directory).
- Start the add-on once and leave it on. It will listen for messages via service calls, as detailed in the README.
  - Note: this means no upload is triggered when the add-on is started, only when a service call is made.

## [0.1.0] - 2018-02-13
