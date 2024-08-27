# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- changelog.md

### Changed

- UI for positions and flows, left swipe for create and edit - right swipe for delete

## [1.0.6] - 2024-08-13

### Added

- sqflite floor for storage
- docker development setup and devcontainer for vscode
- splash screen

### Changed

- storage implementation
- update dependencies
- update gradle plugins
- Refactor DBController to StorageProvider
- Refactor repositories
- update licenses
- update to targetSdkVersion 34
- update README section "Build and deploy" for upload
- version and versioncode to 1.0.6+3

### Removed

- objectbox
- Acronode

### Fixed

- Corrected convertStringToUint8List

## [1.0.5] - 2023-08-11

### Added

- import and export settings
- license page
- MIT license
- README section "Regenerate Licenses"
- option to have multiple root categories
- loop for washing machine mode

### Changed

- update vosk plugin
- update kotlin build.gradle version to 1.8.21

### Fixed

- disable tts on failure to load
- disable voice recognition if not available

## [1.0.4] - 2023-04-15

### Added

- README section "Install on device"
- privacy policy
- washing machine "creeper"

### Changed

- Increase targetSdkVersion to 33

## [1.0.3] - 2023-01-29

### Changed

- Update targetSdkVersion to comply with playstore requirements

## [1.0.2] - 2023-01-29

### Changed

- update version number and description in pubspec

## [1.0.1] - 2023-01-29

### Fixed

- saving voice recognition settings

## [1.0.0] - 2023-01-29

### Added

- README section "Build and deploy"

### Changed

- name of "side star" in "ninja star" to "ninja side star"

### Fixed

- issue with regenerating positions

## [0.9.1] - 2023-01-28

### Added

- workaround for engines

### Changed

- set language after engine was set
- update default washing machines

## [0.9.0] - 2023-01-28

### Added

- icon to AppBar

### Changed

- applicationId and package name for publishing
- build.gradle for app signing

## [0.8.0] - 2023-01-28

### Added

- washing machine image
- loader widget and screen
- positions and flows to default storage
- app icon

### Changed

- flutter_bloc version

## [0.7.0] - 2023-01-08

### Added

- controls for tts settings
- controls for voice recognition settings
- default values for language and engine (google)

### Changed

- font size of dropdowns
- settings to use cards
- styling for controls in acroulette display, especially spacing, centering, margin and padding
- text size for smaller devices
- stopping voice recognition on switching tab
- default playing setting to false

### Fixed

- play control not showing on initial load

## [0.6.1] - 2022-12-21

### Changed

- default for appMode to acroulette

## [0.6.0] - 2022-12-19

### Changed

- Ignore consecutive same positions in random generation

## [0.5.0] - 2022-11-06

### Added

- washing machine mode
- dropdown for changing modes

## [0.4.0] - 2022-11-03

### Added

- README section "Build apk"
- tree view of positions
- option to save positions
- README explanation to install packages  
- dialog for creating positions
- README section "objectbox test"
- option to remove positions
- dialog for editing positions
- dialog for creating categories
- card layout for tree
- validation for adding categories and positions
- previous, random and next buttons
- display for previous and next position
- flow widget with tree view
- dialogs for flow creation, delete, edit

## [0.3.0] - 2022-08-11

### Added

- bottom navigation
- settings form for voice commands
- objectbox for storing settings
- README section "Building"

### Changed

- navigation icon color to black

### Fixed

- some null errors concerning voice commands

## [0.2.2] - 2022-08-04

### Added

- text widget to display positions

## [0.2.1] - 2022-08-04

### Added

- previous and current position command

## [0.2.0] - 2022-08-04

### Added

- new positions

## [0.1.0] - 2022-07-31

### Added

- vosk plugin and model
- voice recognition with vosk
- flutter tts package
