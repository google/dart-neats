// Copyright 2025 Google LLC
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

/// `(Expr<A>, Expr<B>)` for i = 2
String typArgedExprTuple(int i, [int offset = 0]) =>
    listToTuple(typArgedExprAsList(i, offset));

/// `Expr<A> a, Expr<B> b` for i = 2
String typArgedExprArgumentList(int i) {
  return List.generate(i, (i) => 'Expr<${typeArg[i]}> ${arg[i]}').join(',');
}

/// `['Expr<A>', 'Expr<B>']` for i = 2
List<String> typArgedExprAsList(int i, [int offset = 0]) =>
    toArgedExprList(typeArg.skip(offset).take(i));

/// `['A', 'B'] -> ['Expr<A>', 'Expr<B>']`
List<String> toArgedExprList(Iterable<String> typArgs) =>
    typArgs.map((typArg) => 'Expr<$typArg>').toList();

/// Render a list of type expressions to a positional tuple.
String listToTuple(List<String> types) {
  if (types.isEmpty) {
    return '()';
  }
  if (types.length == 1) {
    return '(${types[0]},)';
  }
  return '(${types.join(', ')})';
}

const typeArg = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  //'S', // reserved for use in method templates
  //'T', // reserved for use in method templates
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

final arg = typeArg.map((s) => s.toLowerCase()).toList();
