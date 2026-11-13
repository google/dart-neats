# The Dart backend (`dart.syntax`)

Defaults set in `lib/src/syntax/dart.syntax`. Any `re2c:` configuration below
can be overridden inside a `/*!re2c ... */` block (persists to subsequent blocks
in the file) or inside a `/*!local:re2c ... */` block (scoped to that block
only).

## Invocation

`package:re2c` runs:

```
re2c --lang none --syntax dart.syntax -w -W -I <dir of .re file> <file>
```

 * `-w` selects the 16-bit alphabet (`0..0xFFFF`).
 * `-W` enables all warnings.
 * `-I` resolves `/*!include:re2c "file" */` relative to the `.re` file.

The output is formatted with `dart format`.

## Identifiers used by generated code

| Identifier | Type | Declared by | Purpose |
|---|---|---|---|
| `yyinput` | `String` | user | Input string |
| `yycursor` | `int`, mutable | user | Current index; just past the match when an action runs |
| `yylimit` | `int` | user | Exclusive end index |
| `yymarker` | `int`, mutable | user (when rules backtrack) | Saved fallback index |
| `yyctxmarker` | `int`, mutable | user (when a rule uses `/`) | Saved trailing-context index |
| `yych` | `int` | generated | Current code unit |
| `yystate` | `int` | generated | Automaton state |
| `yyaccept` | `int` | generated | Accepting rule index for fallback |
| `yyt<n>` | `int` | `/*!stags:re2c*/` | Intermediate s-tag positions |
| `yytm<n>` | `List<int>` | `/*!mtags:re2c*/` | Intermediate m-tag position lists |
| `yytl<n>`, `yytr<n>` | `int` | `/*!stags:re2c*/` | Capture group bounds (`re2c:captvars = 1;`) |

Each generated block is wrapped in `{ ... }`, so `yych`, `yystate`, and
`yyaccept` are scoped to the block.

## Primitives (`re2c:YY*`)

| Configuration | Default | Notes |
|---|---|---|
| `YYPEEK` | `yycursor < yylimit ? yyinput.codeUnitAt(yycursor) : 0` | Read current code unit |
| `YYSKIP` | `yycursor++;` | Advance cursor |
| `YYBACKUP` / `YYRESTORE` | `yymarker = yycursor;` / `yycursor = yymarker;` | Save/restore fallback position |
| `YYBACKUPCTX` / `YYRESTORECTX` | `yyctxmarker = yycursor;` / `yycursor = yyctxmarker;` | Save/restore trailing context |
| `YYLESSTHAN` | `yylimit - yycursor < @@{len}` | Bounds check used with `$` |
| `YYEND` | `yycursor >= yylimit` | End-of-input check |
| `YYSHIFT` | `yycursor += @@{shift};` | Fixed-distance cursor shift |
| `YYSTAGP` / `YYSTAGN` | `@@{tag} = yycursor;` / `@@{tag} = -1;` | Set/clear s-tag |
| `YYSHIFTSTAG` | `@@{tag} += @@{shift};` | Shift s-tag |
| `YYRESTORETAG` | `yycursor = @@{tag};` | Restore cursor from s-tag |
| `YYCOPYSTAG` / `YYCOPYMTAG` | `@@{lhs} = @@{rhs};` | Copy tag variable |
| `YYMTAGP` | `@@{tag} = yymtagp(@@{tag}, yycursor);` | User defines `List<int> yymtagp(List<int> tag, int pos) => [...tag, pos];` |
| `YYMTAGN` | `@@{tag} = yymtagn(@@{tag});` | User defines `List<int> yymtagn(List<int> tag) => [...tag, -1];` |
| `YYSHIFTMTAG` | `yyshiftmtag(@@{tag}, @@{shift});` | User defines `yyshiftmtag` |
| `YYFILL` | `yyfill()` | User defines `bool yyfill()` (`re2c:yyfill:enable = 1;`, or `re2c:YYFILL = "yyfill(@@{len});";` with `re2c:eof = -1;`) |
| `YYDEBUG` | `yydebug` | User defines `yydebug(int state, int yych)` (`re2c:debug-output = 1;`) |

Example renaming the input variables to `s`, `p`, `end`, and `m`:

```
/*!re2c
  re2c:YYPEEK = "p < end ? s.codeUnitAt(p) : 0";
  re2c:YYSKIP = "p++;";
  re2c:YYBACKUP = "m = p;";
  re2c:YYRESTORE = "p = m;";
  re2c:YYLESSTHAN = "end - p < @@{len}";
  re2c:YYEND = "p >= end";
  re2c:YYSHIFT = "p += @@{shift};";
  re2c:YYSTAGP = "@@{tag} = p;";
  re2c:YYRESTORETAG = "p = @@{tag};";
*/
```

## End of input

By default `re2c:eof = 0;` and `re2c:yyfill:enable = 0;`. `YYPEEK` returns `0`
past `yylimit`, and `YYLESSTHAN` distinguishes end of input from a `U+0000`
code unit so `$` matches only at `yylimit`.

For NUL-sentinel scanning without per-character bounds checks, set
`re2c:eof = -1;`:

```
/*!re2c
  re2c:eof = -1;
  re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";
*/
```

With `re2c:eof = -1;`, the caller must guarantee a terminating sentinel (such
as `"\x00"`) that no rule crosses, and match `"\x00"` instead of `$`.

## Encoding

`-w` sets the 16-bit UCS-2 alphabet (`0..0xFFFF`). `.re` source files are read
as UTF-8 (`re2c:input-encoding = utf8;`).

| Configuration | Behavior |
|---|---|
| Default (`-w`) | 16-bit code units (`0..0xFFFF`); astral literals are rejected; `[^a]` matches a single code unit |
| `re2c:encoding:utf16 = 1;` | Unicode scalar values (`0..0x10FFFF`); decodes surrogate pairs |
| `re2c:encoding:ucs2 = 0;` | 8-bit code units (`0..0xFF`); only safe when `YYPEEK` yields bytes or input is strictly Latin-1/ASCII |
| `re2c:encoding:utf8 = 1;` | UTF-8 byte automaton (for `Uint8List` inputs) |

## Generated code shape

```dart
{
  var yych = 0;
  var yystate = 0;
  final Error yyactionMustReturnOrContinue;
  if (identical(0, 0)) {
    while (true) {
      switch (yystate) {
        case 0:
          yych = yycursor < yylimit ? yyinput.codeUnitAt(yycursor) : 0;
          if (yych <= 0x002F) {
            yystate = 1;
            continue;
          }
          ...
        case 3:
          {
            return yycursor;
          }
        default:
          throw AssertionError('unreachable');
      }
      // ignore: dead_code
      break;
    }
  } else {
    yyactionMustReturnOrContinue = AssertionError('unreachable');
  }
  throw yyactionMustReturnOrContinue;
}
```

State transitions end with `continue;`. If a semantic action completes normally
without `return`, `throw`, or `continue <label>` (or executes a bare `break;`),
`break;` after `switch (yystate)` becomes reachable and
`throw yyactionMustReturnOrContinue;` fails to compile as potentially
unassigned.

## Directives

| Directive | Purpose |
|---|---|
| `/*!svars:re2c format = "var @@ = -1;\n"; */` | Declare user-named s-tags (`/*!svars:re2c:name ... */` scopes to block `name`) |
| `/*!stags:re2c format = "var @@ = -1;\n"; */` | Declare intermediate s-tags (`yyt<n>`) and capture variables |
| `/*!mvars:re2c format = "var @@ = const <int>[];\n"; */` | Declare user-named m-tags |
| `/*!mtags:re2c format = "var @@ = const <int>[];\n"; */` | Declare intermediate m-tags |
| `/*!include:re2c "defs.re.inc" */` | Include another file (resolved relative to the current `.re` file) |
| `/*!max:re2c*/` | Emit `const yymaxfill = N;` |
| `/*!maxnmatch:re2c*/` | Emit `const yymaxnmatch = N;` |
| `/*!rules:re2c ... */` / `/*!use:re2c ... */` | Define and reuse rule blocks |
