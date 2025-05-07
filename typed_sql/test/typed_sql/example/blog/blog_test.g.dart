// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [BlogDatabase].
extension BlogDatabaseSchema on Database<BlogDatabase> {
  static const _$tables = [_$Post._$table, _$Comment._$table];

  Table<Post> get posts => ExposedForCodeGen.declareTable(
        this,
        _$Post._$table,
      );

  Table<Comment> get comments => ExposedForCodeGen.declareTable(
        this,
        _$Comment._$table,
      );

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
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
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
String createBlogDatabaseTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: BlogDatabaseSchema._$tables,
    );

final class _$Post extends Post {
  _$Post._(
    this.author,
    this.slug,
    this.content,
  );

  @override
  final String author;

  @override
  final String slug;

  @override
  final String content;

  static const _$table = (
    tableName: 'posts',
    columns: <String>['author', 'slug', 'content'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['author', 'slug'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
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
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          author,
          slug,
          content,
        ],
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
  DeleteSingle<Post> delete(
    String author,
    String slug,
  ) =>
      ExposedForCodeGen.deleteSingle(
        byKey(author, slug),
        _$Post._$table,
      );
}

/// Extension methods for building queries against the `posts` table.
extension QueryPostExt on Query<(Expr<Post>,)> {
  /// Lookup a single row in `posts` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Post>,)> byKey(
    String author,
    String slug,
  ) =>
      where((post) =>
          post.author.equalsValue(author) & post.slug.equalsValue(slug)).first;

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
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Post>(
        this,
        _$Post._$table,
        (post) => updateBuilder(
          post,
          ({
            Expr<String>? author,
            Expr<String>? slug,
            Expr<String>? content,
          }) =>
              ExposedForCodeGen.buildUpdate<Post>([
            author,
            slug,
            content,
          ]),
        ),
      );

  /// Delete all rows in the `posts` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Post> delete() => ExposedForCodeGen.delete(this, _$Post._$table);
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
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Post>(
        this,
        _$Post._$table,
        (post) => updateBuilder(
          post,
          ({
            Expr<String>? author,
            Expr<String>? slug,
            Expr<String>? content,
          }) =>
              ExposedForCodeGen.buildUpdate<Post>([
            author,
            slug,
            content,
          ]),
        ),
      );

  /// Delete the row (if any) in the `posts` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Post> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Post._$table);
}

/// Extension methods for expressions on a row in the `posts` table.
extension ExpressionPostExt on Expr<Post> {
  Expr<String> get author =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  Expr<String> get slug =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String> get content =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `comments` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Comment] rows,
  /// where [Comment.author], [Comment.postSlug]
  /// references [Post.author], [Post.slug]
  /// in this row.
  SubQuery<(Expr<Comment>,)> get comments =>
      ExposedForCodeGen.subqueryTable(_$Comment._$table)
          .where((r) => r.author.equals(author) & r.postSlug.equals(slug));
}

extension ExpressionNullablePostExt on Expr<Post?> {
  Expr<String?> get author =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.text);

  Expr<String?> get slug =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String?> get content =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  /// Get [SubQuery] of rows from the `comments` table which
  /// reference this row.
  ///
  /// This returns a [SubQuery] of [Comment] rows,
  /// where [Comment.author], [Comment.postSlug]
  /// references [Post.author], [Post.slug]
  /// in this row, if any.
  ///
  /// If this row is `NULL` the subquery is always be empty.
  SubQuery<(Expr<Comment>,)> get comments =>
      ExposedForCodeGen.subqueryTable(_$Comment._$table).where((r) =>
          r.author.equalsUnlessNull(author).asNotNull() &
          r.postSlug.equalsUnlessNull(slug).asNotNull());

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

final class _$Comment extends Comment {
  _$Comment._(
    this.commentId,
    this.author,
    this.postSlug,
    this.comment,
  );

  @override
  final int commentId;

  @override
  final String author;

  @override
  final String postSlug;

  @override
  final String comment;

  static const _$table = (
    tableName: 'comments',
    columns: <String>['commentId', 'author', 'postSlug', 'comment'],
    columnInfo: <({
      ColumnType type,
      bool isNotNull,
      Object? defaultValue,
      bool autoIncrement,
    })>[
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['commentId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'post',
        columns: ['author', 'postSlug'],
        referencedTable: 'posts',
        referencedColumns: ['author', 'slug'],
      )
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
    required Expr<int> commentId,
    required Expr<String> author,
    required Expr<String> postSlug,
    required Expr<String> comment,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          commentId,
          author,
          postSlug,
          comment,
        ],
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
  DeleteSingle<Comment> delete(int commentId) => ExposedForCodeGen.deleteSingle(
        byKey(commentId),
        _$Comment._$table,
      );
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
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Comment>(
        this,
        _$Comment._$table,
        (comment) => updateBuilder(
          comment,
          ({
            Expr<int>? commentId,
            Expr<String>? author,
            Expr<String>? postSlug,
            Expr<String>? comment,
          }) =>
              ExposedForCodeGen.buildUpdate<Comment>([
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
  Delete<Comment> delete() => ExposedForCodeGen.delete(this, _$Comment._$table);
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
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Comment>(
        this,
        _$Comment._$table,
        (comment) => updateBuilder(
          comment,
          ({
            Expr<int>? commentId,
            Expr<String>? author,
            Expr<String>? postSlug,
            Expr<String>? comment,
          }) =>
              ExposedForCodeGen.buildUpdate<Comment>([
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
      ExposedForCodeGen.deleteSingle(this, _$Comment._$table);
}

/// Extension methods for expressions on a row in the `comments` table.
extension ExpressionCommentExt on Expr<Comment> {
  Expr<int> get commentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String> get author =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String> get postSlug =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  Expr<String> get comment =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.text);

  /// Do a subquery lookup of the row from table
  /// `posts` referenced in
  /// [author], [postSlug].
  ///
  /// The gets the row from table `posts` where
  /// [Post.author], [Post.slug]
  /// is equal to [author], [postSlug].
  Expr<Post> get post => ExposedForCodeGen.subqueryTable(_$Post._$table)
      .where((r) => r.author.equals(author) & r.slug.equals(postSlug))
      .first
      .asNotNull();
}

extension ExpressionNullableCommentExt on Expr<Comment?> {
  Expr<int?> get commentId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  Expr<String?> get author =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  Expr<String?> get postSlug =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.text);

  Expr<String?> get comment =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.text);

  /// Do a subquery lookup of the row from table
  /// `posts` referenced in
  /// [author], [postSlug].
  ///
  /// The gets the row from table `posts` where
  /// [Post.author], [Post.slug]
  /// is equal to [author], [postSlug], if any.
  ///
  /// If this row is `NULL` the subquery is always return `NULL`.
  Expr<Post?> get post => ExposedForCodeGen.subqueryTable(_$Post._$table)
      .where((r) =>
          r.author.equalsUnlessNull(author).asNotNull() &
          r.slug.equalsUnlessNull(postSlug).asNotNull())
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
