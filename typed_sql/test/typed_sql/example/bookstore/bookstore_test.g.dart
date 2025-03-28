// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookstore_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension BookstoreSchema on DatabaseContext<Bookstore> {
  static const _$tables = [_$Author._$table, _$Book._$table];

  /// TODO: Propagate documentation for tables!
  Table<Author> get authors => ExposedForCodeGen.declareTable(
        this,
        _$Author._$table,
      );

  /// TODO: Propagate documentation for tables!
  Table<Book> get books => ExposedForCodeGen.declareTable(
        this,
        _$Book._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

String createBookstoreTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: BookstoreSchema._$tables,
    );

final class _$Author extends Author {
  _$Author._(
    this.authorId,
    this.name,
  );

  @override
  final int authorId;

  @override
  final String name;

  static const _$table = (
    tableName: 'authors',
    columns: <String>['authorId', 'name'],
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
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['authorId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readModel: _$Author._$fromDatabase,
  );

  static Author? _$fromDatabase(RowReader row) {
    final authorId = row.readInt();
    final name = row.readString();
    if (authorId == null && name == null) {
      return null;
    }
    return _$Author._(authorId!, name!);
  }

  @override
  String toString() => 'Author(authorId: "$authorId", name: "$name")';
}

extension TableAuthorExt on Table<Author> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Author> insertLiteral({
    int? authorId,
    required String name,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          authorId != null ? literal(authorId) : null,
          literal(name),
        ],
      );

  /// TODO: document insert
  InsertSingle<Author> insert({
    Expr<int>? authorId,
    required Expr<String> name,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          authorId,
          name,
        ],
      );

  /// TODO: document delete
  DeleteSingle<Author> delete({required int authorId}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(authorId: authorId),
        _$Author._$table,
      );
}

extension QueryAuthorExt on Query<(Expr<Author>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Author>,)> byKey({required int authorId}) =>
      where((author) => author.authorId.equalsLiteral(authorId)).first;

  /// TODO: document updateAll()
  Update<Author> updateAll(
          UpdateSet<Author> Function(
            Expr<Author> author,
            UpdateSet<Author> Function({
              Expr<int> authorId,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Author>([
            authorId,
            name,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Author> updateAllLiteral({
    int? authorId,
    String? name,
  }) =>
      ExposedForCodeGen.update<Author>(
        this,
        _$Author._$table,
        (author) => ExposedForCodeGen.buildUpdate<Author>([
          authorId != null ? literal(authorId) : null,
          name != null ? literal(name) : null,
        ]),
      );

  /// TODO: document delete()}
  Delete<Author> delete() => ExposedForCodeGen.delete(this, _$Author._$table);
}

extension QuerySingleAuthorExt on QuerySingle<(Expr<Author>,)> {
  /// TODO: document update()
  UpdateSingle<Author> update(
          UpdateSet<Author> Function(
            Expr<Author> author,
            UpdateSet<Author> Function({
              Expr<int> authorId,
              Expr<String> name,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Author>(
        this,
        _$Author._$table,
        (author) => updateBuilder(
          author,
          ({
            Expr<int>? authorId,
            Expr<String>? name,
          }) =>
              ExposedForCodeGen.buildUpdate<Author>([
            authorId,
            name,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Author> updateLiteral({
    int? authorId,
    String? name,
  }) =>
      ExposedForCodeGen.updateSingle<Author>(
        this,
        _$Author._$table,
        (author) => ExposedForCodeGen.buildUpdate<Author>([
          authorId != null ? literal(authorId) : null,
          name != null ? literal(name) : null,
        ]),
      );

  /// TODO: document delete()
  DeleteSingle<Author> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Author._$table);
}

extension ExpressionAuthorExt on Expr<Author> {
  /// TODO: document authorId
  Expr<int> get authorId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document references
  SubQuery<(Expr<Book>,)> get books =>
      ExposedForCodeGen.subqueryTable(this, _$Book._$table)
          .where((r) => r.authorId.equals(authorId));
}

extension ExpressionNullableAuthorExt on Expr<Author?> {
  /// TODO: document authorId
  Expr<int?> get authorId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document name
  Expr<String?> get name =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document references
  SubQuery<(Expr<Book>,)> get books =>
      ExposedForCodeGen.subqueryTable(this, _$Book._$table)
          .where((r) => authorId.isNotNull() & r.authorId.equals(authorId));
}

final class _$Book extends Book {
  _$Book._(
    this.bookId,
    this.title,
    this.authorId,
    this.stock,
  );

  @override
  final int bookId;

  @override
  final String? title;

  @override
  final int authorId;

  @override
  final int stock;

  static const _$table = (
    tableName: 'books',
    columns: <String>['bookId', 'title', 'authorId', 'stock'],
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
        autoIncrement: true,
      ),
      (
        type: ExposedForCodeGen.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
      ),
      (
        type: ExposedForCodeGen.integer,
        isNotNull: true,
        defaultValue: 0,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['bookId'],
    unique: <List<String>>[],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[
      (
        name: 'author',
        columns: ['authorId'],
        referencedTable: 'authors',
        referencedColumns: ['authorId'],
      )
    ],
    readModel: _$Book._$fromDatabase,
  );

  static Book? _$fromDatabase(RowReader row) {
    final bookId = row.readInt();
    final title = row.readString();
    final authorId = row.readInt();
    final stock = row.readInt();
    if (bookId == null && title == null && authorId == null && stock == null) {
      return null;
    }
    return _$Book._(bookId!, title, authorId!, stock!);
  }

  @override
  String toString() =>
      'Book(bookId: "$bookId", title: "$title", authorId: "$authorId", stock: "$stock")';
}

extension TableBookExt on Table<Book> {
  /// TODO: document insertLiteral (this cannot explicitly insert NULL for nullable fields with a default value)
  InsertSingle<Book> insertLiteral({
    int? bookId,
    String? title,
    required int authorId,
    int? stock,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          bookId != null ? literal(bookId) : null,
          title != null ? literal(title) : null,
          literal(authorId),
          stock != null ? literal(stock) : null,
        ],
      );

  /// TODO: document insert
  InsertSingle<Book> insert({
    Expr<int>? bookId,
    Expr<String?>? title,
    required Expr<int> authorId,
    Expr<int>? stock,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          bookId,
          title,
          authorId,
          stock,
        ],
      );

  /// TODO: document delete
  DeleteSingle<Book> delete({required int bookId}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(bookId: bookId),
        _$Book._$table,
      );
}

extension QueryBookExt on Query<(Expr<Book>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Book>,)> byKey({required int bookId}) =>
      where((book) => book.bookId.equalsLiteral(bookId)).first;

  /// TODO: document updateAll()
  Update<Book> updateAll(
          UpdateSet<Book> Function(
            Expr<Book> book,
            UpdateSet<Book> Function({
              Expr<int> bookId,
              Expr<String?> title,
              Expr<int> authorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String?>? title,
            Expr<int>? authorId,
            Expr<int>? stock,
          }) =>
              ExposedForCodeGen.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            stock,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Update<Book> updateAllLiteral({
    int? bookId,
    String? title,
    int? authorId,
    int? stock,
  }) =>
      ExposedForCodeGen.update<Book>(
        this,
        _$Book._$table,
        (book) => ExposedForCodeGen.buildUpdate<Book>([
          bookId != null ? literal(bookId) : null,
          title != null ? literal(title) : null,
          authorId != null ? literal(authorId) : null,
          stock != null ? literal(stock) : null,
        ]),
      );

  /// TODO: document delete()}
  Delete<Book> delete() => ExposedForCodeGen.delete(this, _$Book._$table);
}

extension QuerySingleBookExt on QuerySingle<(Expr<Book>,)> {
  /// TODO: document update()
  UpdateSingle<Book> update(
          UpdateSet<Book> Function(
            Expr<Book> book,
            UpdateSet<Book> Function({
              Expr<int> bookId,
              Expr<String?> title,
              Expr<int> authorId,
              Expr<int> stock,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Book>(
        this,
        _$Book._$table,
        (book) => updateBuilder(
          book,
          ({
            Expr<int>? bookId,
            Expr<String?>? title,
            Expr<int>? authorId,
            Expr<int>? stock,
          }) =>
              ExposedForCodeGen.buildUpdate<Book>([
            bookId,
            title,
            authorId,
            stock,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  UpdateSingle<Book> updateLiteral({
    int? bookId,
    String? title,
    int? authorId,
    int? stock,
  }) =>
      ExposedForCodeGen.updateSingle<Book>(
        this,
        _$Book._$table,
        (book) => ExposedForCodeGen.buildUpdate<Book>([
          bookId != null ? literal(bookId) : null,
          title != null ? literal(title) : null,
          authorId != null ? literal(authorId) : null,
          stock != null ? literal(stock) : null,
        ]),
      );

  /// TODO: document delete()
  DeleteSingle<Book> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Book._$table);
}

extension ExpressionBookExt on Expr<Book> {
  /// TODO: document bookId
  Expr<int> get bookId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document title
  Expr<String?> get title =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document authorId
  Expr<int> get authorId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// TODO: document stock
  Expr<int> get stock =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  /// TODO: document references
  Expr<Author> get author =>
      ExposedForCodeGen.subqueryTable(this, _$Author._$table)
          .where((r) => r.authorId.equals(authorId))
          .first
          .assertNotNull();
}

extension ExpressionNullableBookExt on Expr<Book?> {
  /// TODO: document bookId
  Expr<int?> get bookId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document title
  Expr<String?> get title =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document authorId
  Expr<int?> get authorId =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.integer);

  /// TODO: document stock
  Expr<int?> get stock =>
      ExposedForCodeGen.field(this, 3, ExposedForCodeGen.integer);

  /// TODO: document references
  Expr<Author?> get author =>
      ExposedForCodeGen.subqueryTable(this, _$Author._$table)
          .where((r) => authorId.isNotNull() & r.authorId.equals(authorId))
          .first;
}

extension AuthorChecks on Subject<Author> {
  Subject<int> get authorId => has((m) => m.authorId, 'authorId');
  Subject<String> get name => has((m) => m.name, 'name');
}

extension BookChecks on Subject<Book> {
  Subject<int> get bookId => has((m) => m.bookId, 'bookId');
  Subject<String?> get title => has((m) => m.title, 'title');
  Subject<int> get authorId => has((m) => m.authorId, 'authorId');
  Subject<int> get stock => has((m) => m.stock, 'stock');
}
