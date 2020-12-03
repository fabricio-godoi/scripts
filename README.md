# scripts
Many scripts for many luanguages and purposes

## Bash

Scripts for Bash


## Arguments

Example script for parsing arguments for another scripts. It shows how to get values from arguments in the following schema:

```sh
script foo1=bar1 foo2 foo3 bar3
script help | --help | -h
```

Which "foo1" have value "bar1", "foo2" have been defined and "foo3" have the value "bar3". Also, it shows how to check the parameters to show a helpper message for the user.


### Universal Install

This script is intended to provide a method to check which linux distro is running and use the propper package manager to install de dependency. Note that if the package manager does not known the package that it is intended to install, it will return its error.

Usage example:
```sh
source ./bash/universal_install
install sl # Try it for some fun =D
```


### Versioner

This script is used to update the version of ".json" or ".yaml" files that uses version in the following format:

```
{major_revision}.{minor_revision}.{patch_revision}+{build_revision}
```
```yaml
name: My YAML file
version: 1.2.3+4
```
or
```json
{
  "name": "My json file",
  "version": "1.2.3+4"
}
```

Usage example:
```sh
source ./bash/versioner
configure
get_version $(pwd)/my_file.yaml
NEXT_VERSION=$(next_version $(pwd)/my_file.yaml major)
set_version $(pwd)/my_file.yaml $NEXT_VERSION
```

### Flutter

Flutter commands to help development process, such as build, clean and test.

```sh
./flutter help

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
      - ./flutter help
```
