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

/// This library provides documentation strings for generated extension methods.
///
/// @docImport 'package:typed_sql/typed_sql.dart';
library;

/// Documentation categories.
///
/// The names must be synchronized with entries in `dartdoc_options.yaml`.
enum Category {
  schema(name: 'Schema definition'), // ref from annotations
  insertingRows(name: 'Inserting rows'),
  writingQueries(name: 'Writing queries'), // ref from Query
  updateAndDelete(name: 'Update and delete'),
  foreignKeys(name: 'Foreign keys'), // ref from annotation
  joins(name: 'Joins'),
  aggregateFunctions(name: 'Aggregate functions'), // min/max try this
  transactions(name: 'Transactions'), // from transact
  exceptionHandling(name: 'Exception handling'), // from exceptions
  customDataTypes(name: 'Custom data types'), // CustomDataType
  migrations(name: 'Migrations'),
  testing(name: 'Testing'); // Test utils

  const Category({required this.name});
  final String name;

  @override
  String toString() => '{@category $name}';
}

/// Documentation for `.where` on [Query], [SubQuery], [QuerySingle].
///
/// [target] must be either 'Query', 'SubQuery' or 'QuerySingle'.
String where(String target) => '''
    Filter [$target] using `WHERE` clause.

    Returns a [$target] retaining rows from this [$target] where the expression
    returned by [conditionBuilder] evaluates to `true`.
''';

/// Documentation for `.orderBy` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String orderBy(String target) => '''
    Order [$target] using `ORDER BY` clause.

    Returns a [$target] with the same rows as this [$target], but ordered by
    the expressions returned by [builder].

    The [builder] callback must return a list of
    `(Expr<Comparable?>, Order)` records, where the [Order] specifies
    whether results should be sorted in [Order.ascending] or
    [Order.descending] order.

    Regardless of the [Order] given, `null` values are always sorted
    last. If you want `null` values sorted first, you can get this
    behavior using an extra `.isNull()` expression.

    For example:
    ```dart
    final result = await db.books
        .orderBy((book) => [
          // books where title == null will be sorted first now!
          (book.title.isNull(), Order.descending),
          (book.title, Order.ascending),
        ])
        .fetch();
    ```
''';

/// Documentation for `.limit` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String limit(String target) => '''
    Limit [$target] using `LIMIT` clause.

    The resulting [$target] will only return the first [limit] rows.
''';

/// Documentation for `.offset` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String offset(String target) => '''
    Offset [$target] using `OFFSET` clause.

    The resulting [$target] will skip the first [offset] rows.
''';

/// Documentation for `.first` on [Query].
final firstQuery = '''
    Limit [Query] to the first row using `LIMIT` clause.

    This returns a [QuerySingle] which contains at-most one row.
''';

/// Documentation for `.count` on [Query].
final countQuery = '''
    Count number of rows in this [Query] using `COUNT(*)` aggregate
    function.

    The resulting [QuerySingle] will have exactly one row, which is the
    number of rows in the this query.

    This will count all rows, including rows with `null` values. If you
    don't wish to count `null` values, use [where] to filter out such
    rows first.
''';

/// Documentation for `.count` on [SubQuery].
final countSubQuery = '''
    Count number of rows in this [SubQuery] using `COUNT(*)` aggregate
    function.

    The resulting [Expr<int>] will evaluate to the number of rows in this
    [SubQuery].

    This will count all rows, including rows with `null` values. If you
    don't wish to count `null` values, use [where] to filter out such
    rows first.
''';

/// Documentation for `.select` on [Query], [SubQuery] and [QuerySingle].
///
/// [target] must be either 'Query', 'SubQuery' or 'QuerySingle'.
// TODO: Select documentation needs an example!
String select(String target) => '''
    Create a projection of this [$target] using `SELECT` clause.

    The [projectionBuilder] **must** return a [Record] where all the
    values are [Expr] objects. If something else is returned you will
    get a [$target] object which doesn't have any methods!

    All methods and properties on [$target<T>] are extension methods and
    they are only defined for records `T` where all the values are
    [Expr] objects.
''';

/// Documentation for `.join` on [Query].
final innerJoinQuery = '''
    Join this [Query] with another [Query] using `INNER JOIN` clause.

    This method returns an [InnerJoin] object on which you must call either
     * `.all` to get the cartesian product of the two queries, or,
     * `.on` to specify how the two queries should be joined.

    This always creates a `INNER JOIN`, where the `.on` condition can be
    used to control how the two queries are joined.
''';

/// Documentation for `.leftJoin` on [Query].
final leftJoinQuery = '''
    Join this [Query] with another [Query] using `LEFT JOIN` clause.

    This method returns an [LeftJoin] object on which you must call
    `.on` to specify how the two queries should be joined.

    This always creates a `LEFT JOIN`, where the `.on` condition can be
    used to control how the two queries are joined.
''';

/// Documentation for `.join` on [Query].
final rightJoinQuery = '''
    Join this [Query] with another [Query] using `RIGHT JOIN` clause.

    This method returns an [RightJoin] object on which you must call
    `.on` to specify how the two queries should be joined.

    This always creates a `RIGHT JOIN`, where the `.on` condition can be
    used to control how the two queries are joined.
''';

/// Documentation for `.exists` on [Query].
final existsQuery = '''
    Check for existance of rows in this [Query] using `EXISTS` operator.

    This returns a [QuerySingle] which contains exactly one row.
    The value of this query will be `true`, if this [Query] contains
    any rows, even if those rows are entirely `null`s.

    > [!TIP]
    > If you wish to use `.exists()` in a subquery considering
    > using `.asSubQuery.exists()` which returns an [Expr<bool>].
''';

/// Documentation for `.exists` on [SubQuery].
final existsSubQuery = '''
    Check for existance of rows in this [SubQuery] using `EXISTS` operator.

    This returns an [Expr<bool>] that evaluates to `true`, if this [SubQuery]
    contains any rows, even if those rows are entirely `null`s.
''';

/// Documentation for `.stream` on [Query].
final streamQuery = '''
    Query the database for rows in this [Query] as a [Stream].
''';

/// Documentation for `.fetch` on [Query].
final fetchQuery = '''
    Query the database for rows in this [Query] as a [List].
''';

/// Documentation for `.fetch` on [QuerySingle].
final fetchQuerySingle = '''
    Query the database for the row matching this [QuerySingle], if any.

    This returns at-most a single row because [QuerySingle] represents a [Query]
    containing at-most one row.
''';

/// Documentation for `.fetch` on [QuerySingle] when `.fetchOrNulls` is also
/// present.
final fetchQuerySingleWithFetchOrNullsTip = '''
    Query the database for the row matching this [QuerySingle], if any.

    This returns at-most a single row because [QuerySingle] represents a [Query]
    containing at-most one row.

    > [!TIP]
    > If you don't care about whether or not the row is `null` or not
    > present, you can use the convinience method [fetchOrNulls] instead.
''';

/// Documentation for `.fetch` on [QuerySingle].
final fetchOrNullsQuerySingle = '''
    Query the database for the row matching this [QuerySingle], if any.

    > [!WARNING]
    > When using this method it is impossible to distinguish between
    > a result where all values are `null` and zero rows.
''';

/// Documentation for `.union` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String union(String target) => '''
    Combine this [$target] with [other] using `UNION` _set operator_.

    This returns a [$target] containing all the rows from this [$target]
    and [other] with duplicate rows appearing only once.
''';

/// Documentation for `.unionAll` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String unionAll(String target) => '''
    Combine this [$target] with [other] using `UNION ALL` _set operator_.

    This returns a [$target] containing all the rows from this [$target] and
    [other]. Unlike `.union` this retains duplicate rows.
''';

/// Documentation for `.intersection` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String intersection(String target) => '''
  Combine this [$target] with [other] using `INTERSECT` _set operator_.

  This returns a [$target] containing all the rows that appear in both this
  [$target] and [other], with duplicate rows appearing only once.
''';

/// Documentation for `.except` on [Query] and [SubQuery].
///
/// [target] must be either 'Query' or 'SubQuery'.
String except(String target) => '''
    Combine this [$target] with [other] using `EXCEPT` _set operator_.

    This returns a [$target] containing all the rows that appear in this
    [$target] and does not appear in [other], with duplicate rows appearing
    only once.
''';

/// Documentation for `.groupBy` on [Query].
final groupBy = '''
    Create projection for `GROUP BY` clause.

    The [groupBuilder] must return a [Record] where all the values are [Expr]
    objects. If something else is returned you will get a [Group] object which
    doesn't have any methods!

    This returns a [Group] object which has an `.aggregate` method that returns
    a query with a row for each distinct value of the projetion created by
    [groupBuilder]. The `.aggregate` method is used to construct
    _aggregate functions_ over rows of this [Query] for each group.
''';

final asQueryQuerySingle = '''
    Get [Query] with the same rows as this [QuerySingle].

    This returns a [Query] with at-most one row.

    > [!NOTE]
    > This is method is only useful for converting a [QuerySingle]
    > into a [Query] representation, which can be necessary if you wish to pass
    > a [QuerySingle] into a function that only accepts [Query].
''';
