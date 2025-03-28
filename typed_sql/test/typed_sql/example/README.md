# Examples for use in documentation

Examples for use in documentation are written as tests to ensure that they
work as expected!
A region of this file can be marked with:
```dart
// #region <name>
...
// #endregion`
```

> [!WARNING]
> Regions cannot be overlapping, they can perhaps in the future be nested.
> But this is not supported at the moment.

A region can be referenced in markdown using:
        ```dart bookstore_test.dart#initial-data
        <contents-of-region>
        ```

Running `tool/update_doc_examples.dart` will replaced content of the
_fenced code block_ with contents of the region.

Location of the test file need not be accurate, the tool will find all files
whose path ends with `bookstore_test.dart` and report an error if there is more
than one. Similar, the tool will report errors, if region is missing.
