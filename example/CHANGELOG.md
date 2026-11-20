## 0.9.0-wip

* `package:snippets` is now a CLI tool for keeping `@example` markdown code
  blocks up to date with source files in `example/` and `test/` (formerly
  published as `package:example`).

## 0.4.3

* Backwards compatibility: Substitute in "main" when running on "master" channel.

## 0.4.2

* Switch master channel to main.

## 0.4.1

* Update dependencies.

## 0.4.0

* Fix absolute path usage for --output-directory.
* Update dependencies.

## 0.3.1

* Upgrade to Dart 3.0

## 0.3.0

* Removes obsolete `extract_sample.dart` script.
* Removes obsolete `flutter_sample_editor.dart` script.
* Updates all dependencies to latest version.

## 0.2.5

* Make the `--template` argument optional for dartpad and sample samples.

## 0.2.4

* publish the extract_sample command.

## 0.2.3

* Fix sample ID generation to not generate IDs with invalid characters in them (e.g. a ":" in "dart:ui").

## 0.2.2

* Enable parsing of linked samples, add section markers to extracted samples.

## 0.2.1

* Format the sample output, so that it matches the existing tool in the Flutter repo.

## 0.2.0

* Make tool conformant with the tool in the Flutter repo in preparation for switching over.
* Upgrade to latest analyzer release, 2.0.0.

## 0.1.0

* Initial version, ported and modified from the [snippets tool](https://github.com/flutter/flutter/tree/master/dev/snippets) in the Flutter repo.
