## v2.0.0
- Migrated to null-safety.
- API will no-longer return `null` in-place of a `YamlNode`, instead a
  `YamlNode` with `YamlNode.value == null` should be used. These are easily
  created with `wrapAsYamlNode(null)`.

## v1.0.3

- Fixed bug in adding an empty map as a map value.

## v1.0.2

- Throws an error if the final YAML after edit is not parsable.
- Fixed bug in adding to empty map values, when it is followed by other content.

## v1.0.1

- Updated behavior surrounding list and map removal.
- Fixed bug in dealing with empty values.

## v1.0.0

- Initial release.
