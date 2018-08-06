# dart2_migration
Master repo for ensuring that all Angel packages work with Dart ">=1.8.0 &lt;3.0.0"

# Usage
GNU Bash is required to run this tool; ensure you have it, or die!

All functionality is contained in `bin/halo.dart`.

## Cloning repos
The list of projects to manage is contained in `projects.txt`.
To loop through each line and add git submodules where necessary, run `bin/halo.dart clone`.

## Validating all pubspecs:
Checks for the following in every pubspec:
* An `environment` with an SDK dependency on `>=1.8.0 < 3.0.0`.

## Running all tests
* Runs `pub run test` in every repository. If a `.travis.yml` is present, and `script` is defined, that is run instead.
If any tests fail, then the exit code will be 1.

## Pub housekeeping
Checks for:
* `example/*.dart`
* `CHANGELOG.md`

## Running Dart Analyzer
* Note that you can specify a list of names to only analyze certain packages.

## Check for Git changes
