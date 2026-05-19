// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_composite_fk_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [BlogDatabase].
extension BlogDatabaseSchema on Database<BlogDatabase> {
  static final _$tables = [_$Post._$table, _$Comment._$table];

  Table<Post> get posts => $ForGeneratedCode.declareTable(this, _$Post._$table);

  Table<Comment> get comments =>
      $ForGeneratedCode.declareTable(this, _$Comment._$table);

  /// Create tables defined in [BlogDatabase].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [BlogDatabase]. In production it's often better to
  /// use [createBlogDatabaseTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
}

/// Get SQL [DDL statements][1] for tables defined in [BlogDatabase].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [BlogDatabase]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createBlogDatabaseTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: BlogDatabaseSchema._$tables);

final class _$Post extends Post {
  _$Post._(this.author, this.slug, this.content);

  @override
  final String author;

  @override
  final String slug;

  @override
  final String content;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'posts',
    columns: <String>['author', 'slug', 'content'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['author', 'slug'],
    unique: <List<String>>[],
    foreignKeys: [],
    readRow: _$Post._$fromDatabase,
  );

  static Post? _$fromDatabase(RowReader row) {
    final author = row.readString();
    final slug = row.readString();
    final content = row.readString();
    if (author == null && slug == null && content == null) {
      return null;
    }
    return _$Post._(author!, slug!, content!);
  }

  @override
  String toString() =>
      'Post(author: "$author", slug: "$slug", content: "$content")';
}

/// Extension methods for table defined in [Post].
extension TablePostExt on Table<Post> {
  /// Insert row into the `posts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Post> insert({
    required Expr<String> author,
    required Expr<String> slug,
    required Expr<String> content,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [author, slug, content],
  );

  /// Insert row into the `posts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Post> insertValue({
    required String author,
    required String slug,
    required String content,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [author.asExpr, slug.asExpr, content.asExpr],
  );

  /// Bulk insert rows into the `posts` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Post> insertValuesMapped<T>(
    Iterable<T> rows, {
    required String Function(T row) author,
    required String Function(T row) slug,
    required String Function(T row) content,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {'author': author, 'slug': slug, 'content': content},
  );

  /// Delete a single row from the `posts` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Post> delete(String author, String slug) =>
      $ForGeneratedCode.deleteSingle(byKey(author, slug), _$Post._$table);
}

/// Extension methods for building queries against the `posts` table.
extension QueryPostExt on Query<(Expr<Post>,)> {
  /// Lookup a single row in `posts` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Post>,)> byKey(String author, String slug) => where(
    (post) => post.author.equalsValue(author) & post.slug.equalsValue(slug),
  ).first;

  /// Update all rows in the `posts` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Post> update(
    UpdateSet<Post> Function(
      Expr<Post> post,
      UpdateSet<Post> Function({
        Expr<String> author,
        Expr<String> slug,
        Expr<String> content,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Post>(
    this,
    _$Post._$table,
    (post) => updateBuilder(
      post,
      ({Expr<String>? author, Expr<String>? slug, Expr<String>? content}) =>
          $ForGeneratedCode.buildUpdate<Post>([author, slug, content]),
    ),
  );

  /// Delete all rows in the `posts` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Post> delete() => $ForGeneratedCode.delete(this, _$Post._$table);
}

/// Extension methods for building point queries against the `posts` table.
extension QuerySinglePostExt on QuerySingle<(Expr<Post>,)> {
  /// Update the row (if any) in the `posts` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Post> update(
    UpdateSet<Post> Function(
      Expr<Post> post,
      UpdateSet<Post> Function({
        Expr<String> author,
        Expr<String> slug,
        Expr<String> content,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Post>(
    this,
    _$Post._$table,
    (post) => updateBuilder(
      post,
      ({Expr<String>? author, Expr<String>? slug, Expr<String>? content}) =>
          $ForGeneratedCode.buildUpdate<Post>([author, slug, content]),
    ),
  );

  /// Delete the row (if any) in the `posts` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Post> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Post._$table);
}

/// Extension methods for expressions on a row in the `posts` table.
extension ExpressionPostExt on Expr<Post> {
  Expr<String> get author =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get slug =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get content =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `comments` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Comment] rows,
  /// where [Comment.author], [Comment.postSlug]
  /// references [Post.author], [Post.slug]
  /// in this row.
  SubQuery<(Expr<Comment>,)> get comments => $ForGeneratedCode
      .subqueryTable(_$Comment._$table)
      .where((r) => r.author.equals(author) & r.postSlug.equals(slug));
}

extension ExpressionNullablePostExt on Expr<Post?> {
  Expr<String?> get author =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get slug =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get content =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  /// Get [SubQuery] of rows from the `comments` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Comment] rows,
  /// where [Comment.author], [Comment.postSlug]
  /// references [Post.author], [Post.slug]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Comment>,)> get comments => $ForGeneratedCode
      .subqueryTable(_$Comment._$table)
      .where(
        (r) =>
            r.author.equalsUnlessNull(author).asNotNull() &
            r.postSlug.equalsUnlessNull(slug).asNotNull(),
      );

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => author.isNotNull() & slug.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinPostCommentExt
    on InnerJoin<(Expr<Post>,), (Expr<Comment>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Post.author] = [Comment.author] and [Post.slug] = [Comment.postSlug].
  Query<(Expr<Post>, Expr<Comment>)> usingPost() =>
      on((a, b) => a.author.equals(b.author) & a.slug.equals(b.postSlug));
}

extension LeftJoinPostCommentExt on LeftJoin<(Expr<Post>,), (Expr<Comment>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Post.author] = [Comment.author] and [Post.slug] = [Comment.postSlug].
  Query<(Expr<Post>, Expr<Comment?>)> usingPost() =>
      on((a, b) => a.author.equals(b.author) & a.slug.equals(b.postSlug));
}

extension RightJoinPostCommentExt
    on RightJoin<(Expr<Post>,), (Expr<Comment>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Post.author] = [Comment.author] and [Post.slug] = [Comment.postSlug].
  Query<(Expr<Post?>, Expr<Comment>)> usingPost() =>
      on((a, b) => a.author.equals(b.author) & a.slug.equals(b.postSlug));
}

/// `Table<Post>` conflict targets for use with `.onConflict`.
enum PostConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `author`, `slug`.
  primaryKey(['author', 'slug']);

  const PostConflict(this._fields);

  final List<String> _fields;
}

extension InsertPostExt on Insert<Post> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((post, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Post> onConflict(PostConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictPostExt on InsertOnConflict<Post> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `post` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Post> update(
    UpdateSet<Post> Function(
      Expr<Post> post,
      Expr<Post> excluded,
      UpdateSet<Post> Function({
        Expr<String> author,
        Expr<String> slug,
        Expr<String> content,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Post>(
    this,
    (post, excluded) => updateBuilder(
      post,
      excluded,
      ({Expr<String>? author, Expr<String>? slug, Expr<String>? content}) =>
          $ForGeneratedCode.buildUpdate<Post>([author, slug, content]),
    ),
  );
}

extension InsertSinglePostExt on InsertSingle<Post> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((post, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Post> onConflict(PostConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSinglePostExt on InsertOnConflictSingle<Post> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `post` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Post> update(
    UpdateSet<Post> Function(
      Expr<Post> post,
      Expr<Post> excluded,
      UpdateSet<Post> Function({
        Expr<String> author,
        Expr<String> slug,
        Expr<String> content,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Post>(
    this,
    (post, excluded) => updateBuilder(
      post,
      excluded,
      ({Expr<String>? author, Expr<String>? slug, Expr<String>? content}) =>
          $ForGeneratedCode.buildUpdate<Post>([author, slug, content]),
    ),
  );
}

final class _$Comment extends Comment {
  _$Comment._(this.commentId, this.author, this.postSlug, this.comment);

  @override
  final int commentId;

  @override
  final String author;

  @override
  final String postSlug;

  @override
  final String comment;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'comments',
    columns: <String>['commentId', 'author', 'postSlug', 'comment'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['commentId'],
    unique: <List<String>>[],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'post',
        columns: ['author', 'postSlug'],
        referencedTable: 'posts',
        referencedColumns: ['author', 'slug'],
        onDelete: .noAction,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$Comment._$fromDatabase,
  );

  static Comment? _$fromDatabase(RowReader row) {
    final commentId = row.readInt();
    final author = row.readString();
    final postSlug = row.readString();
    final comment = row.readString();
    if (commentId == null &&
        author == null &&
        postSlug == null &&
        comment == null) {
      return null;
    }
    return _$Comment._(commentId!, author!, postSlug!, comment!);
  }

  @override
  String toString() =>
      'Comment(commentId: "$commentId", author: "$author", postSlug: "$postSlug", comment: "$comment")';
}

/// Extension methods for table defined in [Comment].
extension TableCommentExt on Table<Comment> {
  /// Insert row into the `comments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Comment> insert({
    Expr<int>? commentId,
    required Expr<String> author,
    required Expr<String> postSlug,
    required Expr<String> comment,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [commentId, author, postSlug, comment],
  );

  /// Insert row into the `comments` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Comment> insertValue({
    int? commentId,
    required String author,
    required String postSlug,
    required String comment,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [commentId?.asExpr, author.asExpr, postSlug.asExpr, comment.asExpr],
  );

  /// Bulk insert rows into the `comments` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Comment> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? commentId,
    required String Function(T row) author,
    required String Function(T row) postSlug,
    required String Function(T row) comment,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mapping: {
      'commentId': commentId,
      'author': author,
      'postSlug': postSlug,
      'comment': comment,
    },
  );

  /// Delete a single row from the `comments` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Comment> delete(int commentId) =>
      $ForGeneratedCode.deleteSingle(byKey(commentId), _$Comment._$table);
}

/// Extension methods for building queries against the `comments` table.
extension QueryCommentExt on Query<(Expr<Comment>,)> {
  /// Lookup a single row in `comments` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Comment>,)> byKey(int commentId) =>
      where((comment) => comment.commentId.equalsValue(commentId)).first;

  /// Update all rows in the `comments` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Comment> update(
    UpdateSet<Comment> Function(
      Expr<Comment> comment,
      UpdateSet<Comment> Function({
        Expr<int> commentId,
        Expr<String> author,
        Expr<String> postSlug,
        Expr<String> comment,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Comment>(
    this,
    _$Comment._$table,
    (comment) => updateBuilder(
      comment,
      ({
        Expr<int>? commentId,
        Expr<String>? author,
        Expr<String>? postSlug,
        Expr<String>? comment,
      }) => $ForGeneratedCode.buildUpdate<Comment>([
        commentId,
        author,
        postSlug,
        comment,
      ]),
    ),
  );

  /// Delete all rows in the `comments` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Comment> delete() => $ForGeneratedCode.delete(this, _$Comment._$table);
}

/// Extension methods for building point queries against the `comments` table.
extension QuerySingleCommentExt on QuerySingle<(Expr<Comment>,)> {
  /// Update the row (if any) in the `comments` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Comment> update(
    UpdateSet<Comment> Function(
      Expr<Comment> comment,
      UpdateSet<Comment> Function({
        Expr<int> commentId,
        Expr<String> author,
        Expr<String> postSlug,
        Expr<String> comment,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Comment>(
    this,
    _$Comment._$table,
    (comment) => updateBuilder(
      comment,
      ({
        Expr<int>? commentId,
        Expr<String>? author,
        Expr<String>? postSlug,
        Expr<String>? comment,
      }) => $ForGeneratedCode.buildUpdate<Comment>([
        commentId,
        author,
        postSlug,
        comment,
      ]),
    ),
  );

  /// Delete the row (if any) in the `comments` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Comment> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Comment._$table);
}

/// Extension methods for expressions on a row in the `comments` table.
extension ExpressionCommentExt on Expr<Comment> {
  Expr<int> get commentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get author =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get postSlug =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get comment =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `posts` referenced in
  /// [author], [postSlug].
  ///
  /// The gets the row from table `posts` where
  /// [Post.author], [Post.slug]
  /// is equal to [author], [postSlug].
  Expr<Post> get post => $ForGeneratedCode
      .subqueryTable(_$Post._$table)
      .where((r) => r.author.equals(author) & r.slug.equals(postSlug))
      .first
      .asNotNull();
}

extension ExpressionNullableCommentExt on Expr<Comment?> {
  Expr<int?> get commentId =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get author =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get postSlug =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get comment =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  /// Do a subquery lookup of the row from table
  /// `posts` referenced in
  /// [author], [postSlug].
  ///
  /// The gets the row from table `posts` where
  /// [Post.author], [Post.slug]
  /// is equal to [author], [postSlug], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Post?> get post => $ForGeneratedCode
      .subqueryTable(_$Post._$table)
      .where(
        (r) =>
            r.author.equalsUnlessNull(author).asNotNull() &
            r.slug.equalsUnlessNull(postSlug).asNotNull(),
      )
      .first;

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => commentId.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

extension InnerJoinCommentPostExt
    on InnerJoin<(Expr<Comment>,), (Expr<Post>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Comment.author] = [Post.author] and [Comment.postSlug] = [Post.slug].
  Query<(Expr<Comment>, Expr<Post>)> usingPost() =>
      on((a, b) => b.author.equals(a.author) & b.slug.equals(a.postSlug));
}

extension LeftJoinCommentPostExt on LeftJoin<(Expr<Comment>,), (Expr<Post>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Comment.author] = [Post.author] and [Comment.postSlug] = [Post.slug].
  Query<(Expr<Comment>, Expr<Post?>)> usingPost() =>
      on((a, b) => b.author.equals(a.author) & b.slug.equals(a.postSlug));
}

extension RightJoinCommentPostExt
    on RightJoin<(Expr<Comment>,), (Expr<Post>,)> {
  /// Join using the `post` _foreign key_.
  ///
  /// This will match rows where [Comment.author] = [Post.author] and [Comment.postSlug] = [Post.slug].
  Query<(Expr<Comment?>, Expr<Post>)> usingPost() =>
      on((a, b) => b.author.equals(a.author) & b.slug.equals(a.postSlug));
}

/// `Table<Comment>` conflict targets for use with `.onConflict`.
enum CommentConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `commentId`.
  primaryKey(['commentId']);

  const CommentConflict(this._fields);

  final List<String> _fields;
}

extension InsertCommentExt on Insert<Comment> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((comment, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Comment> onConflict(CommentConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCommentExt on InsertOnConflict<Comment> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `comment` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Comment> update(
    UpdateSet<Comment> Function(
      Expr<Comment> comment,
      Expr<Comment> excluded,
      UpdateSet<Comment> Function({
        Expr<int> commentId,
        Expr<String> author,
        Expr<String> postSlug,
        Expr<String> comment,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Comment>(
    this,
    (comment, excluded) => updateBuilder(
      comment,
      excluded,
      ({
        Expr<int>? commentId,
        Expr<String>? author,
        Expr<String>? postSlug,
        Expr<String>? comment,
      }) => $ForGeneratedCode.buildUpdate<Comment>([
        commentId,
        author,
        postSlug,
        comment,
      ]),
    ),
  );
}

extension InsertSingleCommentExt on InsertSingle<Comment> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((comment, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Comment> onConflict(CommentConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCommentExt on InsertOnConflictSingle<Comment> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `comment` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Comment> update(
    UpdateSet<Comment> Function(
      Expr<Comment> comment,
      Expr<Comment> excluded,
      UpdateSet<Comment> Function({
        Expr<int> commentId,
        Expr<String> author,
        Expr<String> postSlug,
        Expr<String> comment,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Comment>(
    this,
    (comment, excluded) => updateBuilder(
      comment,
      excluded,
      ({
        Expr<int>? commentId,
        Expr<String>? author,
        Expr<String>? postSlug,
        Expr<String>? comment,
      }) => $ForGeneratedCode.buildUpdate<Comment>([
        commentId,
        author,
        postSlug,
        comment,
      ]),
    ),
  );
}

/// Extension methods for assertions on [Comment] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension CommentChecks on Subject<Comment> {
  /// Create assertions on [Comment.commentId].
  Subject<int> get commentId => has((m) => m.commentId, 'commentId');

  /// Create assertions on [Comment.author].
  Subject<String> get author => has((m) => m.author, 'author');

  /// Create assertions on [Comment.postSlug].
  Subject<String> get postSlug => has((m) => m.postSlug, 'postSlug');

  /// Create assertions on [Comment.comment].
  Subject<String> get comment => has((m) => m.comment, 'comment');
}

/// Extension methods for assertions on [Post] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension PostChecks on Subject<Post> {
  /// Create assertions on [Post.author].
  Subject<String> get author => has((m) => m.author, 'author');

  /// Create assertions on [Post.slug].
  Subject<String> get slug => has((m) => m.slug, 'slug');

  /// Create assertions on [Post.content].
  Subject<String> get content => has((m) => m.content, 'content');
}
