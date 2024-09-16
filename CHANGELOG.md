# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add introduction and more explanation
- Add CONTRIBUTING.md
- Add 'tools' section in README
- Add .gitlint
- Add description for Acroulette in README
- Add build apk workflow
- Add ls for debugging
- Add names run tests in github
- Add container image for github workflows
- Add username and password to run_tests.yaml
- Add test Dockerfile
- Add Example run tests yaml
- Add 'Run Tests'
- Add tests for complex trees for enableOrDisable
- Add test for enableOrDisable
- Add await enableOrDisable in 'simple tree all enabled, all switched'
- Add test 'simple tree all enabled, all switched' for enableOrDisable
- Add CRUD tests for node_node_dao
- Add CRUD tests for node_dao
- Add CRUD tests for flow_node_dao
- Add test for delete leaf from initial tree
- Add /android/key.properties to gitignore
- Add bundletool

### Changed

- Change some android build settings for working build
- Increase some package versions
- Use flutter version 3.22.2 as in loc dev environment in docker
- Name job to build
- Use flutter version as on local dev machine
- Change permissions to write in run_tests.yaml
- Give write-all permissions
- Change to run debug also on failure
- Try ls debugging other way
- Try dorny/test-reporter
- Use flutter-actions instead of flutter container
- Correct image name to flutter user
- Update run_tests.yaml
- Improve readability for createComplexTreeSwitchedOff
- Make createComplexTreeSwitchedOff more explicit
- Refactor enableOrDisable
- Correct base case for enableOrDisable
- Refactor to createSimpleTreeEnabled and createSimpleTreeDisabled
- Correct query for enableOrDisable
- Correct setting isEnabled in rawQuery
- Start reimplementing enableOrDisable with sqlite raw query
- Move test data creation for trees to trees.dart
- Update CRUD test for settings_pair_dao
- Update CRUD tests for node without parents dao
- Split put into create and update
- Update 'delete leaf from initial tree' test
- Correct NodeNodeDao
- Update changelog with paragraph for UI for positions and flows update
- Use Slidable in flow_position_item
- Use ExpansionTile in flow_view and refactor flow_item
- Merge branch 'feature/3-better-position-slideable-action-controls' into develop
- Change width of createSwitch to 1.5 of size
- Update Styling for PostureTree
- Style PostureListItem
- Use createSwitch in PostureCategoryItem
- Style PostureCategoryItem
- Move 'delete' action to the end for posture items
- Use extentRatio in posture category and list items
- Move controls to ActionPane for posture category item
- Move controls to ActionPane for posture list item
- Make posture list item slidable
- Make posture category item slidable
- Refactor positions UI
- Refactor toggleExpand and isExpanded
- Use ExpansionTile with leading icon
- Use  ExpansionPanelList in PostureTree
- Merge branch 'develop'
- Update licenses

### Removed

- Remove unused part in 'Getting Started'
- Remove signing config for unsigned apk in github actions
- Remove 'as' warning with writing in UPERCASE
- Remove docker warning for test Dockerfile

## [1.0.6] - 2024-08-13

### Changed

- Use versioncode 3
- Increase version to 1.0.6 in pubspec
- Update Readme for upload

## [Acroulette_1.0.6] - 2024-08-13

### Added

- Add changelog.md
- Add splash screen with flutter_native_splash
- Add get for settings_repository
- Add initialize repositories
- Add async await to ModeChange
- Add test settings pair dao
- Add async await and wait Duration to Acroulette bloc test
- Add async await to AcrouletteStart, AcrouletteStop
- Add async and await to VoiceRecognitionStop
- Add padding
- Add nodesWithoutParent list to db_controller
- Add test for node without parents dao
- Add updateNodeIsExpanded
- Add createCategory in node_helper
- Add missing await in db_controller
- Add table for nodes without parent
- Add positions, flows, settings to db_controller
- Add Dockerfile, devcontainer.json and compose.yml for running tests
- Add flow node dao tests
- Add node dao test
- Add count to flownode and node dao
- Add conversion functions and tests
- Add part line in models for generator
- Add path provider as direct dependency
- Add path_provider
- Add isar package and update pubspec
- Add acroulette_icon

### Changed

- Update to targetSdkVersion 34
- Correct enableOrDisable
- Fix initialization error on settings playingKey = true
- Initialize PositionAdministrationBloc with nodes
- Make type of onRecognitionStarted sync again
- Synchronize flowPositions
- Make get playingKey sync
- Update acroulette_bloc_test
- Refactor with repositories
- Refactor storage_provider
- Rename DBController to StorageProvider
- Update async await in acroulette bloc
- Update ChangeMode tests
- Reduce database blocking on initial loadData
- Update putAll for FlowNodes
- Set default values for mode and machine
- Update Gradle plugins
- Update deleteCategory
- Replace put in putSettingsPairValueByKey
- User Insert with return value int or List<Int>
- Make getAllNodeNodesRecursively a rawQuery
- Replace toList with growable false if applicable
- Update to many extension test
- Update insertTree
- Correct createPosture
- Update position_administration_bloc test
- Update functions and return values
- Update acroulette_bloc_test
- Update db_controller_test
- Update import test
- Update toNode, Implement toNodeWithChildren
- Rename put and refactor to insertTree
- Update BasisNodes.json
- Update import export test
- Update position administration bloc test
- Update enableOrDisable
- Update createPosture in db_controller
- Start refactoring position administration bloc test
- Correct node_test
- Correct findNodesWithoutParent in NodeHelper
- Refactor functions nodes and relations
- Update home
- Update getData from export
- Update posture_tree
- Update async await
- Update PositionAdministrationBloc
- Update node
- Move code from position_administration to db_controller
- Update Node database functions
- Merge AcroNode and Node
- Replace deleteManyById with deleteByIds
- Update acro node dao
- Update position_dao
- Correct settings pair dao test group description
- Prepare settings pair for db_controller
- Prepare flow_node_doa for db_controller
- Update pubspec.lock
- Update db_controller with floor Appdatabase
- Refactor imports and tests
- Update node_helper
- Update node_test
- Update acro_node_test import
- Update widgets
- Update plugins
- Refactor for usage of sqflite floor
- Move assets and to_many_extension
- Update and move export and import
- Move convertUint8ListToString and refactor
- Use sqflite floor package
- Correct convertStringToUint8List
- Implement conversion functions
- Correct all linter errors
- Replace toggleableActiveColor
- Replace MaterialStateColor
- Update pubspec.lock
- Use async in db_controller
- Update import to async
- Refactor some isar functions to async
- Ignore libisar.so
- Use context.read in widgets
- Save dbController in AcrouletteBloc
- Update home and settings with context.read
- Refactor main with RepositoryProvider and MultiBlocProvider
- Refactor bloc dispose to close
- Update widgetbook
- CreateLicenseTableRow apply hint
- Update isar functions in multiple files
- Replace getAll for isar
- Rename Mainwidgets
- Update export import with isar
- Update to many extension for isar
- Refactor constructors with super
- Update position_administration_bloc
- Update acroulette_bloc
- Make functions in db_controller synchronous
- Update Node with save links
- Update db_controller
- Correct node model and add Index annotations
- Update licenses
- Update packages
- Rename to db_controller_test
- Update id variable in models
- Import isar package in models
- Update oss_licenses.dart
- Update pubspec.lock
- Update pubspec.yaml

### Removed

- Remove left padding for positions
- Remove left padding for Flows
- Remove setup and tear down in acroulette bloc test
- Remove findParent
- Remove deleteById
- Remove unused acro node test
- Remove unused tests
- Remove unused AcroNode import node dao
- Remove Positions Entity
- Remove BaseEntity from FlowNode
- Remove objectbox generated files
- Remove objectbox

## [Acroulette_1.0.5] - 2023-08-11

### Added

- Add loop to washingmachine mode
- Add test for onSwitchClick
- Add import tests for flow and nodes
- Add AcrouletteBasis.json to assets
- Add ChangeMode test in acroulette bloc test
- Add Random argument to Transition bloc
- Add test for import export
- Add possibility to have many nodes without parent
- Add Acroulette license  and update license page
- Add MIT License
- Add LicenseTableHeader
- Add url_launcher package
- Add License page
- Add generated package licenses
- Add import export constants
- Add createFromMap for FlowNode
- Add convert functions, == and hashCode for Node
- Add convert tests for Node
- Add conversion to JSON and back for AcroNode
- Add test for AcroNode conversion to JSON and back
- Add conversion to JSON and back for FlowNode
- Add test for FlowNode conversion to JSON and back
- Add pick_or_save package
- Add import export settings UI
- Add dispose of voice recognition bloc

### Changed

- Update packages
- Change back to old functions for working switch
- Update put remove helpers in objectboxstore
- Update failing tests
- Update import on empty Objectbox
- Move loadAsset and loadPrivacyPolicy to helpers
- Move objectbox initialization to asset
- Split AcrouletteBasis into flows and nodes
- Update ttsBloc Mock in acroulette bloc test
- Update acroulette bloc test
- Correct voice recognition disablement
- Correct TtsSettings widget
- Disable voice recognition if not available
- Disable tts on failure to load
- Update acroulette bloc tests
- Update Position widget
- Update to many extension test
- Update createFromListOfMaps and createFromString
- Update node import functions
- Update widgetbook imports
- Move components to widgets
- Merge project and website column for license
- Update android kotlin build.gradle version to 1.8.21
- Update oss licenses
- Update Readme for generating oss licenses
- Update URI in LicenseTableRow
- Update ShowLicenseDialog
- Update LicenseTable column width
- Update LicenseTableRow with clickable Text
- Update License page
- Update ImportExportSettings
- Start implementing import
- Implement data export
- Update FlowNode test
- Update FlowNode constants naming
- Update AcroNode test
- Overwrite == and hasCode for AcroNode
- Start implementing export and import functionality
- Correct privacy policy representation
- Update code for vosk plugin
- Update gitignore with .vscode

### Removed

- Remove unused loadAsset from license
- Remove predefined
- Remove unused withTree
- Remove unnecessary code related to AcroNode store
- Remove empty space in Privacy Policy

## [Acroulette_1.0.4] - 2023-04-15

### Added

- Add creeper to washing machines
- Add privacy policy app bar item
- Add privacy policy to assets

### Changed

- Update pubspec.yaml
- Update creeper
- Update privacy policy
- Update targetSdkVersion to comply with playstore android 13
- Update readme for installing bundle on device

## [Acroulette_1.0.3] - 2023-01-29

### Changed

- Update targetSdkVersion to comply with playstore

## [Acroulette_1.0.2] - 2023-01-29

### Changed

- Update description and version in pubspec

## [Acroulette_1.0.1] - 2023-01-29

### Added

- Add missing Form widget in Settings

## [Acroulette_1.0.0] - 2023-01-29

### Changed

- Update names of ninja side star washing machine
- Correct regeneratePositionsList
- Update build and deploy in Readme.md
- Update Readme.md

## [Acroulette_0.9.1] - 2023-01-28

### Changed

- Update default washing machines
- Update names in tts_bloc for better distinction
- Update setter conditions in tts_bloc
- Update flutter_tts and implement workaround
- Set language after engine was set
- Update basic position spellings for better tts
- Update pubspec
- Check for already equal value in settingsBox
- Correct spelling
- Correct to FlowDBStartChangeEvent
- Update pubspec

## [Acroulette_0.9.0] - 2023-01-28

### Added

- Add icon to AppBar

### Changed

- Update applicationId and package name
- Update build.gradle for app signing
- Update pubspec.lock
- Correct spelling

## [Acroulette_0.8.0] - 2023-01-28

### Added

- Add icon
- Add many new positions and four washing machines
- Add loader to home widget
- Add washing machine image

### Changed

- Correct asset image import and path
- Create loader widget and test it in widgetbook
- Update flutter_bloc version

### Removed

- Remove unused import
- Remove unnecessary Equatable from Events

## [Acroulette_0.7.0] - 2023-01-08

### Added

- Add stopping voiceRecognition on switching tab
- Add key to TtsChangeState
- Add size to widgets constant
- Add washingMachineDropdown
- Add default values for language and engine
- Add showPositions
- Add labels for language and engine
- Add getter and setter to tts settings
- Add horizontal padding for submitbutton
- Add more information in tts_settings
- Add cards to settings
- Add controls for tts to settings

### Changed

- Adjust spacing and paddings
- Refactor AcrouletteBloc
- Refactor VoiceRecognitionStart event
- Update AcrouletteFlowState to distinguish by flowName
- Set default playingKey in database to false
- Move onBlocEvents to start of constructor
- Return empty Container on AcrouletteInitialState
- Revert to version 3.5.3. of flutter_tts
- Adjust styling for tts settings
- Set default value for tts engine to google
- Update flutter_tts
- Update tts settings
- Refactor tts_bloc
- Update TtsBloc to load settings from database on start
- Adjust styling in home
- Update onRecognitionStarted and TransitionBloc
- Update text size for smaller devices
- Correct not showing play control on first load
- Update buildWhen condition
- Refactor blocs
- Center icons of iconbutton
- Refactor VoiceRecognitionBloc constructor
- Center dropdown Text and adjust margin
- Adjust styling for dropdowns
- Update typing in controlButton
- Update state label position
- Update show positions and base widgets
- Move state label and remove spacing
- Adjust fontsize for dropdowns
- Update return type of _getDefaultVoice
- Move isLanguageInstalled part to tts_bloc
- Get language and engine from database on initialize
- Update isLanguageInstalled
- Move eventhandlers in acroulette bloc
- Update Tts settings
- Rename file to tts_settings
- Create VoiceRecognitionSettings widget
- Create Heading widget

### Removed

- Remove unused AcrouletteRecognizeCommandState
- Remove unused texts
- Remove showing initialize model

## [Acroulette_0.6.1] - 2022-12-21

### Changed

- Refactor home to use modeSelect and getControls
- Set default for appMode to acroulette
- Create PairValueException
- Replace Fluttertts with tts_bloc
- Update gradle version to 7.6
- Move tts and voice recognition loading to app start

## [Acroulette_0.6.0] - 2022-12-19

### Added

- Add washing machine selection support
- Add AcrouletteFlowEvent and State
- Add ignoring consecutive same postures
- Add flowPositions and update AcrouletteChangeMode
- Add mode bloc and connect it to acroulette bloc
- Add dropdown for choosing washing machines

### Changed

- Update mode with transitions
- Replace context acrouletteBloc with variable

### Removed

- Remove unused constant

## [Acroulette_0.5.0] - 2022-11-06

### Added

- Add washing machine mode
- Add dropdown for changing modes

### Changed

- Move constants to settings.dart
- Ignore vscode launch.json

## [Acroulette_0.4.0] - 2022-11-03

### Added

- Add create and edit flow dialogs and logic
- Add fake floating action button for flows
- Add flow administration bloc
- Add delete posture dialog
- Add test for validator in edit and save
- Add random posture button and vertical space in home
- Add previous and next buttons
- Add logic for validator
- Add validator function to arguments
- Add delete category dialog
- Add createCategory method
- Add create category dialog
- Add category icon button
- Add test for onEditClick
- Add edit posture dialog
- Add edit IconButton
- Add test for onDeleteClick in position administration bloc
- Add remove methods to objectboxstore
- Add hash methods to acroulette_state
- Add flat_buffers as direct dependency
- Add bloc and meta as direct dependency
- Add CRUD methodes to posture components
- Add CRUD methods to position_administration_bloc
- Add objectboxstore test for findParent
- Add path property to posture components
- Add create_posture_dialg
- Add hint for getting packages to Readme
- Add regeeratePositionList
- Add predefined flag to AcroNode
- Add objectbox-mod again
- Add enabled property on acro node
- Add putMany nodes to objectboxstore
- Add enable property to list item
- Add enable property to posture list item
- Add expand functionality to posture tree
- Add add button for category item
- Add more complex tree to widgetbook
- Add space between components in posture list item
- Add onChanged and delete functions to PostureListItem
- Add widgetbook and stories for Posture components
- Add PositionBox
- Add command for building apk to readme

### Changed

- Create show delete posture dialog
- Correct findParent for rootNode
- Correct validator functions
- Create flow widgets
- Show previous and next positions in home
- Connect control buttons with bloc logic
- Insert validator in create posture dialog
- Correct filename spelling
- Correct onDeleteClick for categories
- Activate on DeleteClick for categories
- Update onSaveClick test
- Update Layout with cards and icons
- Create edit category dialog
- Replace isCategory with isPosture
- Refactor node to have flag is leaf
- Improve dialog visuals
- Update widgetbook
- Update regeneratePositionsList
- Close creat posture dialog on save
- Update createPosture
- Update deletePosture
- Update onEditClick
- Update onSaveClick method for postures
- Simplifiy Node creation
- Replace print with log in SimpleBlocObserver
- Replace runZoned in main
- Move findRoot to objectboxstore
- Refactor PositionAdministrationInitialState
- Rename to textSettingsFormField
- Correct transition_bloc tests
- Update main with objectbox create arguments
- Generalize acroulette_bloc
- Update Readme with objectbox test
- Replace Container with SizedBox
- Update packages
- Update positions page
- Refactor node logic
- Implement switcher functionality for posture category item
- Implement switcher functionality for posture list item
- Refactor node and acro_node to comply with objectbox
- Correct posture tree and add left intendation
- Improve posture category item
- Refactor PostureTree and story for it
- Replace Icon with Iconbutton in PostureCategoryItem
- Create AcroNode
- Update node model and add tests
- Update widgetbook imports
- Start working at a tree model and posture_tree
- Move posture_items to posture_tree
- Rename some figures
- Refactore PostureListItem
- Refactor PostureCategoryItem

### Removed

- Remove unused comments
- Remove unused flutterTts in main
- Remove unused import
- Remove warning from Flows
- Remove add form for posture tab
- Remove unused import from positions

## [Acroulette_0.3.0] - 2022-08-11

### Added

- Add dynamic commands to AcrouletteBloc
- Add text_settings_form_field widget
- Add SettingsPair
- Add Objectbox to main
- Add flow and position model
- Add commands model
- Add objectbox
- Add form for customization of the commands
- Add BottomNavigationBar

### Changed

- Update version
- Correct null errors
- Update Readme
- Update packages
- Refactor bloc test without mockito
- Correct objectbox setup
- Refactor model initialization time
- Adjust navigation icon color and text to black
- Write Textstyle to variable

### Removed

- Remove unused import

## [Acroulette_0.2.2] - 2022-08-04

### Added

- Add Text widget to display figures

### Changed

- Improve UI
- Improve visual feedback of the state of the app

### Removed

- Remove unnecessary code in main.dart

## [Acroulette_0.2.1] - 2022-08-04

### Added

- Add previous, current position commands

## [Acroulette_0.2] - 2022-08-04

### Added

- Add tests for bloc logic
- Add tests for acroulette_bloc
- Add mockito and build_runner packages
- Add new figures

### Changed

- Use TransitionStatus.created to trigger tts

## [Acroulette_Proof_of_Concept] - 2022-07-31

### Added

- Add logic for proof of concept
- Add BlocProvider for VoiceRecognition
- Add code to include flutter_tts
- Add first tests

### Changed

- Update NewTransition test
- Update transition and voice recognition bloc
- Update vosk_flutter_plugin import
- Initial Commit with blocs

[unreleased]: https://github.com/samxela/acroulette/compare/1.0.6..HEAD
[1.0.6]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.6..1.0.6
[Acroulette_1.0.6]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.5..Acroulette_1.0.6
[Acroulette_1.0.5]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.4..Acroulette_1.0.5
[Acroulette_1.0.4]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.3..Acroulette_1.0.4
[Acroulette_1.0.3]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.2..Acroulette_1.0.3
[Acroulette_1.0.2]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.1..Acroulette_1.0.2
[Acroulette_1.0.1]: https://github.com/samxela/acroulette/compare/Acroulette_1.0.0..Acroulette_1.0.1
[Acroulette_1.0.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.9.1..Acroulette_1.0.0
[Acroulette_0.9.1]: https://github.com/samxela/acroulette/compare/Acroulette_0.9.0..Acroulette_0.9.1
[Acroulette_0.9.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.8.0..Acroulette_0.9.0
[Acroulette_0.8.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.7.0..Acroulette_0.8.0
[Acroulette_0.7.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.6.1..Acroulette_0.7.0
[Acroulette_0.6.1]: https://github.com/samxela/acroulette/compare/Acroulette_0.6.0..Acroulette_0.6.1
[Acroulette_0.6.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.5.0..Acroulette_0.6.0
[Acroulette_0.5.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.4.0..Acroulette_0.5.0
[Acroulette_0.4.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.3.0..Acroulette_0.4.0
[Acroulette_0.3.0]: https://github.com/samxela/acroulette/compare/Acroulette_0.2.2..Acroulette_0.3.0
[Acroulette_0.2.2]: https://github.com/samxela/acroulette/compare/Acroulette_0.2.1..Acroulette_0.2.2
[Acroulette_0.2.1]: https://github.com/samxela/acroulette/compare/Acroulette_0.2..Acroulette_0.2.1
[Acroulette_0.2]: https://github.com/samxela/acroulette/compare/Acroulette_Proof_of_Concept..Acroulette_0.2

<!-- generated by git-cliff -->
