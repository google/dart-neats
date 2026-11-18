---
name: re2c-scanners
description: Use when writing or editing `.re` files for package:re2c, generating Dart scanners/lexers/tokenizers with re2c, or debugging generated `*.dart` scanner output; covers the yyinput/yycursor/yylimit contract, required rules, tags, encodings and regeneration.
---

# Writing re2c scanners for Dart

`package:re2c` compiles `<name>.re` (Dart source with `/*!re2c ... */` blocks)
to `<name>.dart` using an installed `re2c` >= 4.4. Regenerate with
`dart run build_runner build` or `dart run re2c`; verify with
`dart run re2c --check`.

References:

 * [references/dart-syntax.md](references/dart-syntax.md): generated Dart
   contract and overridable defaults.
 * [references/re2c.md](references/re2c.md): re2c rule language, regular
   expressions, configurations, directives, and warnings.

## Block contract

A block reads `String yyinput` from index `yycursor` up to (excluding)
`yylimit`, one UTF-16 code unit at a time, and runs the matched rule's action
with `yycursor` pointing just past the match:

```dart
int scanDigits(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [0-9]+ { return yycursor; }
    $      { return -1; }
    *      { return -1; }
  */
}
```

`yyinput`, `yycursor`, and `yylimit` must be in scope; `yycursor` must be
mutable.

## Required rules and declarations

1. **Every action must `return`, `throw`, or `continue <label>`** an enclosing
   labelled loop. Falling off the end of an action fails to compile
   (`yyactionMustReturnOrContinue`); a bare `continue;` continues the inner
   state loop and spins forever.
2. **Always include a `*` rule.** It matches any code unit when no other rule
   matches and advances `yycursor` by 1.
3. **Always include a `$` rule** (end of input), unless using a sentinel with
   `re2c:eof = -1;`.
4. **Declare `var yymarker = yycursor;`** when rules backtrack, and
   `var yyctxmarker = yycursor;` when rules use variable-length trailing
   contexts (`/`).
5. **Declare tag variables** when using `@tag` or `#tag`: place
   `/*!svars:re2c format = "var @@ = -1;\n"; */` and
   `/*!stags:re2c format = "var @@ = -1;\n"; */` before the block and set
   `re2c:tags = 1;` inside it (`mvars`/`mtags` with `var @@ = const <int>[];`
   for `#`). When multiple functions in one file use tags, name the directives
   and blocks (`/*!svars:re2c:name ... */`, `/*!local:re2c:name ... */`).
6. **Never edit generated `.dart` files** by hand; edit the `.re` source and
   regenerate.

## Scanning in a loop

```dart
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

Model lexer modes as separate blocks or functions; re2c start conditions
(`<mode>`) are not enabled.

## Characters are UTF-16 code units

 * Alphabet is `0..0xFFFF`. `"é"` and `"\u20AC"` match one code unit;
   `[^\x00-\x7F]` matches any non-ASCII code unit.
 * Astral characters are surrogate pairs (two code units). Astral literals and
   code-point classes require `re2c:encoding:utf16 = 1;`.
 * NUL (`\x00`) is an ordinary code unit; `$` matches end of input via a bounds
   check.

## Common errors

| Symptom | Cause | Fix |
|---|---|---|
| `yyactionMustReturnOrContinue` unassigned | Action fell off the end (or used bare `break;`) | End every action with `return`, `throw`, or `continue <label>` |
| Hangs forever | Bare `continue;` in an action | `continue <label>;` on your outer loop |
| `control flow is undefined for empty string` | Missing `$` rule | Add `$ { ... }` |
| `bad code point` | Astral literal without UTF-16 mode | Set `re2c:encoding:utf16 = 1;` |
| `-Wmatch-empty-string` with captures | `$` rule combined with `re2c:captvars = 1;` | Use a NUL sentinel (`re2c:eof = -1;`, match `"\x00"`) |
| Undefined `yymarker` / `yyctxmarker` / `yyt1` | Missing variable declaration | Declare the variable or `stags`/`svars` directive before the block |
| Undefined `yymtagp` / `yyfill` / `yydebug` | Feature requires user helper functions | Define the helper functions (see [dart-syntax.md](references/dart-syntax.md)) |
