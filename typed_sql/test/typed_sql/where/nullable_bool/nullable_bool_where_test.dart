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

import 'package:typed_sql/typed_sql.dart';

import '../../testrunner.dart';

part 'nullable_bool_where_test.g.dart';

abstract final class TestDatabase extends Schema {
  Table<Item> get items;
}

@PrimaryKey(['id'])
abstract final class Item extends Row {
  int get id;
  bool? get value;
}

typedef _Case = ({
  String name,
  Expr<bool?> Function(Expr<Item> item) where,
  List<int> expected,
});

final _cases = <_Case>[
  // use column value as-is
  (
    name: '.where(.value)',
    where: (item) => item.value,
    expected: [1],
  ),

  // AND expression is evaluated
  (
    name: '.where(.value.and(true))',
    where: (item) => item.value.and(toExpr(true)),
    expected: [1],
  ),
  (
    name: '.where(.value.and(false))',
    where: (item) => item.value.and(toExpr(false)),
    expected: <int>[],
  ),
  (
    name: '.where(.value.and(null))',
    where: (item) => item.value.and(toExpr(null as bool?)),
    expected: <int>[],
  ),

  // OR expression is evaluated
  (
    name: '.where(.value.or(true))',
    where: (item) => item.value.or(toExpr(true)),
    expected: [1, 2, 3],
  ),
  (
    name: '.where(.value.or(false))',
    where: (item) => item.value.or(toExpr(false)),
    expected: [1],
  ),
  (
    name: '.where(.value.or(null))',
    where: (item) => item.value.or(toExpr(null as bool?)),
    expected: [1],
  ),

  // Operator `&` evaluations
  (
    name: '.where(.value & true)',
    where: (item) => item.value & toExpr(true),
    expected: [1],
  ),
  (
    name: '.where(.value & false)',
    where: (item) => item.value & toExpr(false),
    expected: <int>[],
  ),
  (
    name: '.where(.value & null)',
    where: (item) => item.value & toExpr(null as bool?),
    expected: <int>[],
  ),

  // Operator `|` evaluations
  (
    name: '.where(.value | true)',
    where: (item) => item.value | toExpr(true),
    expected: [1, 2, 3],
  ),
  (
    name: '.where(.value | false)',
    where: (item) => item.value | toExpr(false),
    expected: [1],
  ),
  (
    name: '.where(.value | null)',
    where: (item) => item.value | toExpr(null as bool?),
    expected: [1],
  ),

  // Constants on the LHS
  (
    name: '.where(true.and(.value))',
    where: (item) => toExpr(true).and(item.value),
    expected: [1],
  ),
  (
    name: '.where(false.and(.value))',
    where: (item) => toExpr(false).and(item.value),
    expected: <int>[],
  ),
  (
    name: '.where(null.and(.value))',
    where: (item) => toExpr(null as bool?).and(item.value),
    expected: <int>[],
  ),
  (
    name: '.where(true.or(.value))',
    where: (item) => toExpr(true).or(item.value),
    expected: [1, 2, 3], // TRUE OR NULL evaluates to TRUE
  ),
  (
    name: '.where(null.or(.value))',
    where: (item) => toExpr(null as bool?).or(item.value),
    expected: [1], // NULL OR TRUE -> TRUE. NULL OR FALSE/NULL -> NULL.
  ),
  (
    name: '.where(true.and(.value))',
    where: (item) => toExprLiteral(true).and(item.value),
    expected: [1],
  ),
  (
    name: '.where(false.and(.value))',
    where: (item) => toExprLiteral(false).and(item.value),
    expected: <int>[],
  ),
  (
    name: '.where(null.and(.value))',
    where: (item) => toExprLiteral(null as bool?).and(item.value),
    expected: <int>[],
  ),
  (
    name: '.where(true.or(.value))',
    where: (item) => toExprLiteral(true).or(item.value),
    expected: [1, 2, 3], // TRUE OR NULL evaluates to TRUE
  ),
  (
    name: '.where(null.or(.value))',
    where: (item) => toExprLiteral(null as bool?).or(item.value),
    expected: [1], // NULL OR TRUE -> TRUE. NULL OR FALSE/NULL -> NULL.
  ),

  // combined evaluations
  (
    name: '.where(.value & .value)',
    where: (item) => item.value & item.value,
    expected: [1],
  ),
  (
    name: '.where(.id.equalsValue(1) & .value)',
    where: (item) => item.id.equalsValue(1).and(item.value),
    expected: [1],
  ),

  // Mixed nullability expressions
  (
    name: '.where(.id.equalsValue(2).or(.value))',
    where: (item) => item.id.equalsValue(2).or(item.value),
    expected: [1, 2],
  ),
  (
    name: '.where(.id.equalsValue(3).and(.value))',
    where: (item) => item.id.equalsValue(3).and(item.value),
    expected: <int>[],
  ),

  // .equalsUnlessNull
  (
    name: '.where(.value.equalsUnlessNull(toExpr(true)))',
    where: (item) => item.value.equalsUnlessNull(toExpr(true)),
    expected: [1],
  ),
  (
    name: '.where(.value.equalsUnlessNull(toExprLiteral(true)))',
    where: (item) => item.value.equalsUnlessNull(toExprLiteral(true)),
    expected: [1],
  ),
  (
    name: '.where(.value.equalsUnlessNull(toExpr(false)))',
    where: (item) => item.value.equalsUnlessNull(toExpr(false)),
    expected: [2],
  ),
  (
    name: '.where(.value.equalsUnlessNull(toExprLiteral(false)))',
    where: (item) => item.value.equalsUnlessNull(toExprLiteral(false)),
    expected: [2],
  ),

  // Null coalescing
  (
    name: '.where(.value.orElseValue(true))',
    where: (item) => item.value.orElseValue(true),
    expected: [1, 3],
  ),
  (
    name: '.where(.value.isNull().or(.value))',
    where: (item) => item.value.isNull().or(item.value),
    expected: [1, 3],
  ),

  // Explicit boolean checks
  (
    name: '.where(.value.isTrue())',
    where: (item) => item.value.isTrue(),
    expected: [1],
  ),
  (
    name: '.where(.value.isFalse())',
    where: (item) => item.value.isFalse(),
    expected: [2], // Crucially, this safely excludes row 3 (NULL)
  ),
  (
    name: '.where(.value.isNull())',
    where: (item) => item.value.isNull(),
    expected: [3],
  ),
  (
    name: '.where(.value.isNotNull())',
    where: (item) => item.value.isNotNull(),
    expected: [1, 2],
  ),

  // Safe negation by coalescing first
  (
    name: '.where(~.value.orElseValue(false))',
    where: (item) => ~item.value.orElseValue(false),
    expected: [2, 3], // NULL -> FALSE -> NOT FALSE = TRUE
  ),
  (
    name: '.where(~.value.orElseValue(true))',
    where: (item) => ~item.value.orElseValue(true),
    expected: [2], // NULL -> TRUE -> NOT TRUE = FALSE
  ),

  // SQL Equality (=) vs IS NOT DISTINCT FROM
  (
    name: '.where(.value.equalsUnlessNull(toExpr(false)))',
    where: (item) => item.value.equalsUnlessNull(toExpr(false)),
    expected: [2],
  ),
  (
    name: '.where(.value.equalsUnlessNull(toExpr(null as bool?)))',
    where: (item) => item.value.equalsUnlessNull(toExpr(null as bool?)),
    expected: <int>[], // NULL = NULL evaluates to NULL (falsy)
  ),
  (
    name: '.where(.value.isNotDistinctFrom(toExpr(null as bool?)))',
    where: (item) => item.value.isNotDistinctFrom(toExpr(null as bool?)),
    expected: [3], // NULL IS NOT DISTINCT FROM NULL evaluates to TRUE
  ),

  // AST Constant folding optimizations
  (
    name: '.where(.value & toExprLiteral(true))',
    where: (item) => item.value & toExprLiteral(true),
    expected: [1],
  ),
  (
    name: '.where(.value & toExprLiteral(false))',
    where: (item) => item.value & toExprLiteral(false),
    expected: <int>[],
  ),
  (
    name: '.where(toExprLiteral(true).and(.value))',
    where: (item) => toExprLiteral(true).and(item.value),
    expected: [1],
  ),

  // 3VL Precedence and mixed fields
  (
    name: '.where(.value | .value.isNull())',
    where: (item) => item.value | item.value.isNull(),
    expected: [1, 3],
  ),
  (
    name: '.where(.id.equalsValue(2).or(.value))',
    where: (item) => item.id.equalsValue(2).or(item.value),
    expected: [1, 2],
  ),
  (
    name: '.where(.id.equalsValue(3).and(.value))',
    where: (item) => item.id.equalsValue(3).and(item.value),
    expected: <int>[],
  ),

  // Operator Precedence & Grouping
  (
    name: '.where((.id.equalsValue(2) | .id.equalsValue(3)) & .value.isNull())',
    where: (item) =>
        (item.id.equalsValue(2) | item.id.equalsValue(3)) & item.value.isNull(),
    expected: [3],
  ),
  (
    name: '.where(.id.equalsValue(2) | (.id.equalsValue(3) & .value.isNull()))',
    where: (item) =>
        item.id.equalsValue(2) | (item.id.equalsValue(3) & item.value.isNull()),
    expected: [2, 3],
  ),
];

void main() {
  // Insert a row for each possible value of a nullable boolean: TRUE, FALSE and NULL.
  // Using the `id` for easier sanity checks.
  final r = TestRunner<TestDatabase>(
    setup: (db) async {
      await db.createTables();
      await db.items.insert(id: toExpr(1), value: toExpr(true)).execute();
      await db.items.insert(id: toExpr(2), value: toExpr(false)).execute();
      await db.items.insert(id: toExpr(3), value: toExpr(null)).execute();
    },
  );

  for (final c in _cases) {
    r.addTest(c.name, (db) async {
      final ids = await db.items
          .where(c.where)
          .select((item) => (item.id,))
          .orderBy((id) => [(id, .ascending)])
          .fetch();
      check(ids).deepEquals(c.expected);
    });
  }

  r.run();
}
