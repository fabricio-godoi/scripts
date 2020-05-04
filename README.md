# scripts
Many scripts for many luanguages and purposes

## Bash

Scripts for Bash


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
NEXT_VERSION=$(next_version $(pwd)/my_file.yaml)
set_version $(pwd)/my_file.yaml $NEXT_VERSION
```