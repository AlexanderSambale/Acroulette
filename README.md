# Acroulette

Acroulette is an app for Acroyoga, which gives you random positions and you have to figure out a way to get there.

Normally you are involved with your hands and feet, so you can control the app with speech. There is speech recognition build in. On certain command words you get the next random position. It can also tell you the position before and switch to it, tell the current position and go to the next one. The position is then announced by an TextToSpeech engine. It also has a washing machine mode, where you can train positions in sequence.

You can configure almost everything. Change the command words, add new positions, add new washing machines, delete them, disable them. Just have fun and be creative. :)

## Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Tools

### gitlint

<https://jorisroovers.com/gitlint/latest/>

#### Quickstart

Install `gitlint`

```bash
pip install gitlint
```

Change to root directory of this repository and install the `commit-msg` hook.

```bash
gitlint install-hook
```

<https://jorisroovers.com/gitlint/latest/getting_started/>

#### Alternatives for gitlint

commitlint (Node.js)
fit-commit (Ruby)
node-commit-msg (Node.js)

<https://jorisroovers.com/gitlint/latest/alternatives/>

## Building

if never run before:

```bash
flutter pub get
```

```bash
flutter pub run build_runner build
```

### Build apk

```bash
flutter build apk
```

### Build and deploy

```bash
flutter build appbundle -v 
```

For upload to play console:

```bash
bundletool build-apks --bundle=./build/app/outputs/bundle/release/app-release.aab --output=./build/app/outputs/apks/release/app-release.apks --ks=~/upload-keystore.jks --ks-key-alias=upload
```

Use this file for upload.

#### Install on device

If file exists

```bash
rm ./build/app/outputs/apks/release/app-release.apks
```

```bash
bundletool build-apks --bundle=./build/app/outputs/bundle/release/app-release.aab --output=./build/app/outputs/apks/release/app-release.apks --ks=~/upload-keystore.jks --ks-key-alias=upload
```

```bash
bundletool install-apks --apks=./build/app/outputs/apks/release/app-release.apks
```

## Regenerate Licenses

```bash
flutter pub run flutter_oss_licenses:generate.dart
```

## Run Tests

```bash
flutter test
```
