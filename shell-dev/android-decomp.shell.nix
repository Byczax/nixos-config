{ pkgs ? import <nixpkgs> { config = {
  }; } }:
pkgs.mkShell {
  buildInputs = [
    pkgs.apksigner
    pkgs.openjdk
    pkgs.apktool
    pkgs.android-tools
    pkgs.jadx
  ];
  shell = pkgs.zsh;
}
# apksigner sign --ks key.jks new-app.apk
# apktool b old-app-folder -o new-app.apk
# adb install/install-multiple
# adb logcat
# keytool -genkeypair -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias appkey
# js-beatify from npm
