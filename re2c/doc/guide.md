# Writing scanners with `package:re2c`

[re2c][1] compiles regular expressions with actions into a deterministic finite
automaton emitted as a `while` loop over a `switch` on the current state. The
generated scanner allocates nothing and runs in linear time. `package:re2c`
runs `re2c` with a Dart backend and formats the output, compiling `scanner.re`
to `scanner.dart` next to it.

## Setup

```sh
dart pub add dev:build_runner dev:re2c
```

Install `re2c` >= 4.4 and make sure it is on `PATH`, or set `RE2C_EXECUTABLE`:

 * `brew install re2c`
 * `conda install -c conda-forge re2c`

## A `.re` file is a Dart file

Code outside `/*!re2c ... */` blocks is copied verbatim. Each block reads from
a `String` named `yyinput`, starting at index `yycursor` up to `yylimit`, and
executes the action of the matching rule.

Here is a scanner for the key in a `key = value` line, `lib/src/scanner.re`:

```dart
/// Returns the end of the key starting at [yycursor], or -1.
int scanKey(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [a-zA-Z_][a-zA-Z0-9_-]* { return yycursor; }
    $                        { return -1; }
    *                        { return -1; }
  */
}
```

Three rules:

 * A regular expression followed by an action. re2c picks the longest match,
   breaking ties by rule order. When the action runs, `yycursor` points just
   past the match.
 * `$` matches the end of input. Required whenever a rule can reach the end of
   input.
 * `*` matches any single code unit when nothing else matches. Always include
   it so the scanner covers all inputs.

Run the generator:

```sh
dart run build_runner build      # or: dart run re2c
```

Commit both `scanner.re` and the generated `scanner.dart`.

## Scanning in a loop

To scan an entire input, wrap the block in a labelled loop and `continue` that
label from each action:

```dart
/// Counts words, or returns -1 on an unexpected character.
int countWords(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var count = 0;
  loop:
  while (true) {
    /*!re2c
      [a-zA-Z]+ { count++; continue loop; }
      [ \t\n]+  { continue loop; }
      $         { return count; }
      *         { return -1; }
    */
  }
}
```

Because the generated scanner is itself a `while (true)` loop, a bare
`continue;` continues the inner state machine rather than the outer token loop.
Every action must `return`, `throw`, or `continue` an outer label; falling off
the end of an action fails to compile.

## Backtracking and `yymarker`

When one rule is a prefix of a longer rule, re2c saves the fallback position in
`yymarker`:

```dart
int classify(String yyinput, int yycursor, int yylimit) {
  var yymarker = yycursor;
  /*!re2c
    "<!--" { return 1; }
    "<"    { return 2; }
    $      { return 0; }
    *      { return -1; }
  */
}
```

If `yymarker` is needed and not declared, the analyzer reports an undefined
identifier in the generated `.dart` file. Variable-length trailing contexts
(`a / b`, matching `a` only when followed by `b`) use `yyctxmarker` the same
way.

## Submatch extraction with tags

Tags record positions inside a match. Declare the tag variables with
`svars`/`stags`, enable `re2c:tags = 1;`, and mark positions with `@name`:

```dart
({String key, String value})? scanAssignment(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!svars:re2c format = "var @@ = -1;\n"; */
  /*!stags:re2c format = "var @@ = -1;\n"; */
  /*!re2c
    re2c:tags = 1;

    [ \t]* @k1 [a-zA-Z_]+ @k2 [ \t]* "=" [ \t]* @v1 [^\n]* @v2 $ {
      return (key: yyinput.substring(k1, k2), value: yyinput.substring(v1, v2));
    }
    $ { return null; }
    * { return null; }
  */
}
```

`svars` declares the named tags (`k1`, `k2`, `v1`, `v2`); `stags` declares the
intermediate variables re2c uses.

## Characters are UTF-16 code units

Scanners read `yyinput.codeUnitAt(yycursor)`, so each step inspects one UTF-16
code unit (`0` to `0xFFFF`):

 * `"é"` and `"\u20AC"` match one code unit each; `[^\x00-\x7F]` matches any
   non-ASCII code unit.
 * `"😀"` is a surrogate pair (two code units) and is rejected unless the block
   sets `re2c:encoding:utf16 = 1;`, which decodes surrogate pairs into Unicode
   scalar values.
 * End of input is distinguished from a `U+0000` code unit by a bounds check,
   so NUL may appear in `yyinput`.

## CI check

```sh
dart run re2c --check
```

Exits with status 1 if any `.dart` file is out of date with its `.re` source.

## Examples

 * [example/tokenizer.re](../example/tokenizer.re): expression tokenizer.
 * [test/scanners/](../test/scanners/): runnable test scanners covering tags,
   captures, trailing contexts, UTF-16 surrogate pairs, and NUL-sentinel
   scanners.
 * [re2c manual][2]: regular expression syntax, configurations, and directives.

[1]: https://re2c.org/
[2]: https://re2c.org/manual/manual_c.html
