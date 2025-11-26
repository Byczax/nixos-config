{ pkgs ? import <nixpkgs> { config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  }; } }:
let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformToolsVersion = "34.0.5";
    buildToolsVersions = [ "34.0.0" ];
    platformVersions = [ "34" ];
    includeEmulator = false;
    includeNDK = false;
  };
in 
pkgs.mkShell {
  name = "flutter-env";

  buildInputs = [
    pkgs.zsh
    pkgs.jdk
    pkgs.flutter
    pkgs.android-tools
    androidPkgs.androidsdk
  ];
  shell = pkgs.zsh;

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk17}/lib/openjdk
    export PATH=$JAVA_HOME/bin:$PATH

    # Use a writable SDK location outside the Nix store
    export ANDROID_SDK_ROOT=$HOME/Android/Sdk
    export ANDROID_HOME=$ANDROID_SDK_ROOT

    export CHROME_EXECUTABLE=$(which firefox)

    # Ensure the directory exists
    mkdir -p $ANDROID_SDK_ROOT

    echo "Using Java version: $(java -version 2>&1 | head -n 1)"
    echo "Android SDK root set to $ANDROID_SDK_ROOT"
  '';

  env = {
    FLUTTER_ROOT = "${pkgs.flutter}";
  };
}

