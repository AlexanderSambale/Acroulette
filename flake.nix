{
  description = "Flutter 3.32.8 development shell with Android SDK and JDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [
            "34.0.0"
            "30.0.3"
          ];
          platformVersions = [
            "30"
            "31"
            "32"
            "33"
            "34"
          ];
          abiVersions = [
            "armeabi-v7a"
            "arm64-v8a"
          ];
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            flutter
            jdk17
            androidSdk
          ];

          # Set environment variables for Flutter and Android
          shellHook = ''
            export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk"
            export CHROME_EXECUTABLE="/etc/profiles/per-user/samxela/bin/vivaldi"
            export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2"
          '';
        };
      }
    );
}
