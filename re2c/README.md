Compile [re2c][1] lexer definitions to fast Dart scanners
========================================================

`package:re2c` compiles `<name>.re` files into `<name>.dart` files with
zero-allocation DFA scanners using an installed `re2c` executable.
`package:re2c` is intended to be used as a `dev_dependency`.

## Install

```sh
dart pub add dev:build_runner dev:re2c
```

Install `re2c` >= 4.4 and set `RE2C_EXECUTABLE` if it is not on `PATH`:

 * `brew install re2c`
 * `conda install -c conda-forge re2c`

## Write a scanner

A `.re` file is a Dart file with `/*!re2c ... */` blocks. By default the
generated code scans a `String` named `yyinput` by UTF-16 code unit, from
`yycursor` to `yylimit`, and reports end of input with the `$` rule:

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

Rules to keep in mind:

 * Every action must `return`, `throw`, or `continue` a labelled loop; falling
   off the end of an action is a compile-time error.
 * Characters are UTF-16 code units: `"é"` is `0xE9`, and `"😀"` is a surrogate
   pair that only matches with `re2c:encoding:utf16 = 1;`.
 * Most [re2c configurations][2] can be overridden per file; see
   [example/tokenizer.re](example/tokenizer.re) and [test/scanners/](test/scanners/).

See [doc/guide.md](doc/guide.md) for a walkthrough, and run
`dart run skills@ get` to install the
[re2c-scanners](skills/re2c-scanners/SKILL.md) skill.

## Generate

```sh
dart run build_runner build
```

This writes `<name>.dart` next to each `<name>.re`. `dart run re2c` does the
same thing:

```sh
dart run re2c            # all .re files in the package
dart run re2c --check    # for CI: exit 1 if a generated file is out of date
```

[1]: https://re2c.org/
[2]: https://re2c.org/manual/manual_c.html#configurations
