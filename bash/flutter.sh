#!/bin/bash

##########################################################################
## Some script dependencies

## Use as parse_yaml file.yaml
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

## Use as $(get_version $(pwd)/pubspec.yaml)
function get_version {
   export $(parse_yaml $1 | grep version | xargs)
   echo "${version}"
}

##########################################################################
## Main script

# Script config
CURDIR=$(pwd)
BASEDIR=$(dirname "$0")

__HELP__="
   Generator for swagger files
   Parameters:
      help|--help|-h                Show this message
      build                         Start flutter builder runner
      watch                         Start flutter builder runner in watch mode
      icons                         Update flutter launcher icons in Android and iOs
      splash                        Update flutter splash screen in Android and iOs
      bundle                        Create the Android bundle for release in store
      apk                           Create the Android apk for release in test environment
      ios                           Create release for iOS
      build_version                 Get the build version from pubspec.yaml eg.: 1.2.3
      build_number                  Get the build number from pubspec.yaml eg.: 1
      test                          Run all unit test with coverage check
      clean                         Run a command to clean all possible problem files and cache

   Examples:
      - $0 help
"

if [ $# -eq 0 ]; then echo "$__HELP__"; fi

# Read parameters given in the script in the format xpto=abc
for arg in "$@"; do
   if [[ $arg == -h || $arg == --help || $arg == help ]]; then
      echo "$__HELP__"
   elif [[ $arg == build ]]; then
      flutter pub get
      flutter packages pub run build_runner build --delete-conflicting-outputs
   elif [[ $arg == watch ]]; then
      flutter pub get
      flutter packages pub run build_runner watch --delete-conflicting-outputs
   elif [[ $arg == icons ]]; then
      flutter pub run flutter_launcher_icons:main
   elif [[ $arg == splash ]]; then
      flutter pub pub run flutter_native_splash:create
   elif [[ $arg == bundle ]]; then
      VERSION=$(get_version $(pwd)/pubspec.yaml)
      echo "Building bundle version $VERSION"
      flutter pub get
      flutter packages pub run build_runner build --delete-conflicting-outputs
      flutter build appbundle --release
   elif [[ $arg == apk ]]; then
      VERSION=$(get_version $(pwd)/pubspec.yaml)
      echo "Building bundle version $VERSION"
      flutter pub get
      flutter packages pub run build_runner build --delete-conflicting-outputs
      flutter build apk --release
   elif [[ $arg == ios ]]; then
      VERSION=$(get_version $(pwd)/pubspec.yaml)
      echo "Building bundle version $VERSION"
      flutter pub get
      flutter packages pub run build_runner build --delete-conflicting-outputs
      flutter build ios --release
   elif [[ $arg == build_version ]]; then
      BUILD_VERSION=$(get_version $(pwd)/pubspec.yaml)
      echo ${BUILD_VERSION%%+*}
   elif [[ $arg == build_number ]]; then
      BUILD_NUMBER=$(get_version $(pwd)/pubspec.yaml)
      echo ${BUILD_NUMBER##*+}
   elif [[ $arg == test ]]; then
      flutter test --coverage ./lib
      lcov -r coverage/lcov.info '*/__test*__/*' -o coverage/lcov_cleaned.info
      genhtml coverage/lcov_cleaned.info --output=coverage
   elif [[ $arg == clean ]]; then
      flutter packages run build_runner clean
      flutter pub cache repair
      rm -rf "$BASEDIR"/pubspec.lock
      rm -rf "$BASEDIR"/buid
      rm -rf "$BASEDIR"/ios/podfile.lock
      rm -rf "$BASEDIR"/ios/Flutter/Flutter.framework
      flutter clean
   else
      echo "Unknown command"
      exit 0
   fi
done
