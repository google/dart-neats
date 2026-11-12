// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Kinds of tokens produced by [nextToken].
enum TokenKind { number, identifier, string, operator, whitespace, error, end }

/// A token in the input, from [start] to [end] (exclusive).
typedef Token = ({TokenKind kind, int start, int end});

/// Scans the token starting at [start] in [input].
///
/// Returns a token of kind [TokenKind.end] at the end of the input, and of
/// kind [TokenKind.error] for a character that does not start any token.
Token nextToken(String input, int start) {
  final yyinput = input;
  final yylimit = input.length;
  var yycursor = start;
  var yymarker = start;

  /*!re2c
    digit  = [0-9];
    number = digit+ ("." digit+)? ([eE] [+-]? digit+)?;
    ident  = [a-zA-Z_][a-zA-Z0-9_]*;
    string = "\"" ([^"\\\x00] | "\\" [^\x00])* "\"";

    number                  { return _token(TokenKind.number, start, yycursor); }
    ident                   { return _token(TokenKind.identifier, start, yycursor); }
    string                  { return _token(TokenKind.string, start, yycursor); }
    [-+*/=<>!]"="? | [()]   { return _token(TokenKind.operator, start, yycursor); }
    [ \t\r\n]+              { return _token(TokenKind.whitespace, start, yycursor); }
    $                       { return _token(TokenKind.end, start, start); }
    *                       { return _token(TokenKind.error, start, yycursor); }
  */
}

Token _token(TokenKind kind, int start, int end) =>
    (kind: kind, start: start, end: end);

/// Splits [input] into tokens, stopping at the first error.
List<Token> tokenize(String input) {
  final tokens = <Token>[];
  var position = 0;
  while (true) {
    final token = nextToken(input, position);
    tokens.add(token);
    if (token.kind == TokenKind.end || token.kind == TokenKind.error) {
      return tokens;
    }
    position = token.end;
  }
}
