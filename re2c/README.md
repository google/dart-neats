Compiles [re2c][1] lexer definitions (`<name>.re`) into `<name>.dart` files with
zero-allocation DFA scanners using an installed `re2c` executable. Intended to
be used as a `dev_dependency`.

**Disclaimer:** This is not an officially supported Google product.

## Install

```sh
dart pub add dev:build_runner dev:re2c
dart run skills@ get  # optional agent skill
```

Install `re2c` >= 4.4 (or set `RE2C_EXECUTABLE`):

 * `brew install re2c`
 * `conda install -c conda-forge re2c`

## Write a scanner

A `.re` file is a Dart file with `/*!re2c ... */` blocks scanning `yyinput` by
UTF-16 code unit from `yycursor` to `yylimit`:

```dart
/// Returns the end of the run of ASCII digits starting at [yycursor], or -1.
int scanDigits(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [0-9]+ { return yycursor; }
    $      { return -1; }
    *      { return -1; }
  */
}
```

Keep in mind:

 * Every action must `return`, `throw`, or `continue` a labelled loop; falling
   off the end is a compile-time error.
 * Characters are UTF-16 code units: `"é"` is `0xE9`, and `"😀"` only matches
   with `re2c:encoding:utf16 = 1;`.
 * Most [re2c configurations][2] can be overridden per file; see the
   [guide][3], [example/tokenizer.re][4], and [test/scanners/][5].

## Generate

```sh
dart run build_runner build
```

Or run the CLI directly:

```sh
dart run re2c          # all .re files in the package
dart run re2c --check  # exit 1 if a generated file is out of date
```

[1]: https://re2c.org/
[2]: https://re2c.org/manual/manual_c.html#configurations
[3]: https://github.com/google/dart-neats/blob/master/re2c/doc/guide.md
[4]: https://github.com/google/dart-neats/blob/master/re2c/example/tokenizer.re
[5]: https://github.com/google/dart-neats/tree/master/re2c/test/scanners
