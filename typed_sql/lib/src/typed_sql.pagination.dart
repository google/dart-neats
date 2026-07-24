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

part of 'typed_sql.dart';

/// A [PageRequest] fully describes how to fetch one page:
/// - how to order rows ([orderBy]),
/// - how to filter to "rows after the cursor" ([where]),
/// - how to build a cursor from a fetched row ([cursorOf]), and
/// - how to build the request for the next page ([withCursor]).
///
/// Note: page fetching itself does not know about a concrete cursor
/// or sort-direction, keeping it open for more generic paging queries.
///
/// {@category writing_queries}
abstract interface class PageRequest<T extends Row, C extends Object> {
  /// Maximum number of rows to fetch in a single [Page].
  int get pageSize;

  /// Cursor to fetch rows after, or `null` to fetch the first page.
  C? get cursor;

  /// Build the `ORDER BY` expressions for this request.
  List<(Expr<Comparable?>, Order)> orderBy(Expr<T> row);

  /// Build the `WHERE` expression selecting rows after [cursor].
  ///
  /// Only ever called when [cursor] is not `null`.
  Expr<bool?> where(Expr<T> row);

  /// Build a cursor identifying [row].
  C cursorOf(T row);

  /// Build the request for the page after this one, given the [cursor] of
  /// the last row in the current page.
  PageRequest<T, C> withCursor(C cursor);
}

/// A single page of rows.
final class Page<T extends Row, C extends Object> {
  /// Rows in this page, ordered as specified by the [PageRequest].
  final List<T> items;

  /// Cursor identifying the row after which the next page begins, or `null`
  /// if [items] is the last page of rows.
  C? get nextCursor => nextPageRequest?.cursor;

  /// A ready-to-use [PageRequest] for fetching the next [Page], or `null` if
  /// [items] is the last page of rows.
  final PageRequest<T, C>? nextPageRequest;

  Page._(this.items, this.nextPageRequest);

  /// `true` if there are more rows after this [Page].
  bool get hasMore => nextCursor != null;
}
