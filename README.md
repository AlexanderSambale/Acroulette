# acroulette

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
