# re2c reference

Summary of the [re2c manual][1] for writing `.re` files in Dart. Dart-specific
details are in [dart-syntax.md](dart-syntax.md).

## File structure

A `.re` file is Dart code containing `/*!re2c ... */` blocks:

```
/*!re2c
  <configurations>
  <named definitions>
  <rules>
*/
```

Code outside blocks is copied verbatim. A block with only configurations and
named definitions emits no code and applies to subsequent blocks in the file.

## Rules

```
<regexp> { <action> }
<regexp> / <regexp> { <action> }      // trailing context
$        { <action> }                 // end of input
*        { <action> }                 // default fallback
```

 * re2c chooses the **longest** match, breaking ties by **first listed** rule.
 * `*` consumes one code unit and matches when no other rule matches.
 * `$` matches at `yylimit` without advancing `yycursor`.
 * `a / b` matches `a` only when followed by `b` and leaves `yycursor` after
   `a`. Variable-length trailing contexts require `yyctxmarker`.

## Named definitions

```
digit  = [0-9];
number = digit+ ("." digit+)?;
```

Definitions are substituted as parenthesized sub-expressions and must be
defined before use.

## Regular expressions

| Syntax | Meaning |
|---|---|
| `"abc"` | Case-sensitive literal |
| `'abc'` | Case-insensitive literal |
| `[a-z0-9_]` | Character class (escape `]`, `\`, `-` with `\`) |
| `[^...]` | Negated character class |
| `[^]` | Any character (including `\n`) |
| `.` | Any character except `\n` |
| `r*`, `r+`, `r?` | Repetition |
| `r{n}`, `r{n,}`, `r{n,m}` | Bounded repetition |
| `r1 r2` | Concatenation |
| `r1 \| r2` | Alternation |
| `r1 \ r2` | Character class difference |
| `(r)` | Grouping (capture group when `re2c:captvars = 1;`) |
| `(!r)` | Non-capturing group when captures are enabled |
| `@name` | s-tag (single position) |
| `#name` | m-tag (list of positions inside a repetition) |

Escapes in literals and classes: `\a \b \f \n \r \t \v \\`, `\xHH`, `\uHHHH`,
`\UHHHHHHHH`, `\ooo`.

## Submatch extraction

 * **s-tags (`@name`)**: `re2c:tags = 1;`. Records a single index in `name` (or
   `-1` if unmatched). Declare variables with `/*!svars:re2c ... */` and
   `/*!stags:re2c ... */`.
 * **m-tags (`#name`)**: `re2c:tags = 1;`. Records multiple indices across a
   repetition via user-defined `yymtagp` and `yymtagn`. Declare variables with
   `/*!mvars:re2c ... */` and `/*!mtags:re2c ... */`.
 * **Captures (`re2c:captvars = 1;`)**: Binds `(...)` groups to
   `yytl<n>`/`yytr<n>` variables declared via `/*!stags:re2c ... */`.

## Common configurations

| Configuration | Effect |
|---|---|
| `re2c:eof = <n>;` | End-of-input sentinel value (`0` by default; `-1` disables `$`) |
| `re2c:tags = 1;` | Enable `@name` and `#name` tags |
| `re2c:captvars = 1;` | Enable `yytl<n>`/`yytr<n>` capture variables |
| `re2c:case-insensitive = 1;` | Make `"..."` literals case-insensitive |
| `re2c:case-inverted = 1;` | Swap case sensitivity of `"..."` and `'...'` |
| `re2c:encoding:utf16 = 1;` | Decode UTF-16 surrogate pairs |
| `re2c:YYPEEK = "...";` | Customize input reading and other `YY*` primitives |

## Directives

| Directive | Purpose |
|---|---|
| `/*!re2c ... */` | Scanner block |
| `/*!re2c:name ... */` | Named scanner block |
| `/*!svars:re2c format = "..."; */` | Declare user s-tag variables (`@@` is the name) |
| `/*!stags:re2c format = "..."; */` | Declare intermediate s-tag variables |
| `/*!mvars:re2c ... */`, `/*!mtags:re2c ... */` | Declare user and intermediate m-tag variables |
| `/*!include:re2c "file" */` | Include another `.re` file |
| `/*!rules:re2c:name ... */` | Reusable rule block |
| `/*!use:re2c:name ... */` | Instantiate a `rules` block |
| `/*!max:re2c*/` | Emit `const yymaxfill = N;` |
| `/*!maxnmatch:re2c*/` | Emit `const yymaxnmatch = N;` |
| `/*!ignore:re2c ... */` | Ignored comment block |

## Common warnings

| Warning | Meaning |
|---|---|
| `-Wunreachable-rules` | Rule is shadowed by an earlier rule |
| `-Wmatch-empty-string` | Rule can match `""` |
| `-Wundefined-control-flow` | Input not covered by rules; add `*` and `$` |
| `-Wsentinel-in-midrule` | Sentinel appears inside a pattern when `re2c:eof = -1;` |
| `-Wnondeterministic-tags` | Ambiguous tag placement |

[1]: https://re2c.org/manual/manual_c.html
