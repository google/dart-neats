// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension PrimaryDatabaseSchema on DatabaseContext<PrimaryDatabase> {
  static const _$tables = [
    (
      tableName: 'users',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'userId',
          type: int,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: true,
        ),
        (
          name: 'name',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'email',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$User._$primaryKey,
      unique: <List<String>>[
        ['email']
      ],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[],
    ),
    (
      tableName: 'packages',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'packageName',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'likes',
          type: int,
          isNotNull: true,
          defaultValue: 0,
          autoIncrement: false,
        ),
        (
          name: 'ownerId',
          type: int,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'publisher',
          type: String,
          isNotNull: false,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$Package._$primaryKey,
      unique: <List<String>>[],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[
        (
          name: 'owner',
          columns: ['ownerId'],
          referencedTable: 'users',
          referencedColumns: ['userId'],
        )
      ],
    ),
    (
      tableName: 'likes',
      columns: <({
        String name,
        Type type,
        bool isNotNull,
        Object? defaultValue,
        bool autoIncrement,
      })>[
        (
          name: 'userId',
          type: int,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        ),
        (
          name: 'packageName',
          type: String,
          isNotNull: true,
          defaultValue: null,
          autoIncrement: false,
        )
      ],
      primaryKey: _$Like._$primaryKey,
      unique: <List<String>>[],
      foreignKeys: <({
        String name,
        List<String> columns,
        String referencedTable,
        List<String> referencedColumns,
      })>[],
    ),
  ];

  /// TODO: Propagate documentation for tables!
  Table<User> get users => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'users',
        columns: _$User._$fields,
        primaryKey: _$User._$primaryKey,
        deserialize: _$User.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Package> get packages => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'packages',
        columns: _$Package._$fields,
        primaryKey: _$Package._$primaryKey,
        deserialize: _$Package.new,
      );

  /// TODO: Propagate documentation for tables!
  Table<Like> get likes => ExposedForCodeGen.declareTable(
        context: this,
        tableName: 'likes',
        columns: _$Like._$fields,
        primaryKey: _$Like._$primaryKey,
        deserialize: _$Like.new,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

String createPrimaryDatabaseTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: PrimaryDatabaseSchema._$tables,
    );

final class _$User extends User {
  _$User(RowReader row)
      : userId = row.readInt()!,
        name = row.readString()!,
        email = row.readString()!;

  @override
  final int userId;

  @override
  final String name;

  @override
  final String email;

  static const _$fields = [
    'userId',
    'name',
    'email',
  ];

  static const _$primaryKey = ['userId'];

  @override
  String toString() =>
      'User(userId: "$userId", name: "$name", email: "$email")';
}

extension TableUserExt on Table<User> {
  /// TODO: document create
  Future<User> create({
    required int userId,
    required String name,
    required String email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(userId),
          literal(name),
          literal(email),
        ],
      );

  /// TODO: document insert
  Future<User> insert({
    required Expr<int> userId,
    required Expr<String> name,
    required Expr<String> email,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          userId,
          name,
          email,
        ],
      );

  /// TODO: document delete
  Future<void> delete({required int userId}) => byKey(userId: userId).delete();
}

extension QueryUserExt on Query<(Expr<User>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<User>,)> byKey({required int userId}) =>
      where((user) => user.userId.equalsLiteral(userId)).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<User> Function(
            Expr<User> user,
            Update<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        this,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            name,
            email,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        this,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );

  /// TODO: document byXXX()}
  QuerySingle<(Expr<User>,)> byEmail(String email) =>
      where((user) => user.email.equalsLiteral(email)).first;
}

extension QuerySingleUserExt on QuerySingle<(Expr<User>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<User> Function(
            Expr<User> user,
            Update<User> Function({
              Expr<int> userId,
              Expr<String> name,
              Expr<String> email,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<User>(
        asQuery,
        (user) => updateBuilder(
          user,
          ({
            Expr<int>? userId,
            Expr<String>? name,
            Expr<String>? email,
          }) =>
              ExposedForCodeGen.buildUpdate<User>([
            userId,
            name,
            email,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? userId,
    String? name,
    String? email,
  }) =>
      ExposedForCodeGen.update<User>(
        asQuery,
        (user) => ExposedForCodeGen.buildUpdate<User>([
          userId != null ? literal(userId) : null,
          name != null ? literal(name) : null,
          email != null ? literal(email) : null,
        ]),
      );
}

extension ExpressionUserExt on Expr<User> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document name
  Expr<String> get name => ExposedForCodeGen.field(this, 1);

  /// TODO: document email
  Expr<String> get email => ExposedForCodeGen.field(this, 2);

  /// TODO: document references
  SubQuery<(Expr<Package>,)> get packages => ExposedForCodeGen.subqueryTable(
        reference: this,
        tableName: 'packages',
        columns: _$Package._$fields,
        primaryKey: _$Package._$primaryKey,
        deserialize: _$Package.new,
      ).where((r) => r.ownerId.equals(userId));
}

final class _$Package extends Package {
  _$Package(RowReader row)
      : packageName = row.readString()!,
        likes = row.readInt()!,
        ownerId = row.readInt()!,
        publisher = row.readString();

  @override
  final String packageName;

  @override
  final int likes;

  @override
  final int ownerId;

  @override
  final String? publisher;

  static const _$fields = [
    'packageName',
    'likes',
    'ownerId',
    'publisher',
  ];

  static const _$primaryKey = ['packageName'];

  @override
  String toString() =>
      'Package(packageName: "$packageName", likes: "$likes", ownerId: "$ownerId", publisher: "$publisher")';
}

extension TablePackageExt on Table<Package> {
  /// TODO: document create
  Future<Package> create({
    required String packageName,
    required int likes,
    required int ownerId,
    required String? publisher,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(packageName),
          literal(likes),
          literal(ownerId),
          literal(publisher),
        ],
      );

  /// TODO: document insert
  Future<Package> insert({
    required Expr<String> packageName,
    required Expr<int> likes,
    required Expr<int> ownerId,
    required Expr<String?> publisher,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          packageName,
          likes,
          ownerId,
          publisher,
        ],
      );

  /// TODO: document delete
  Future<void> delete({required String packageName}) =>
      byKey(packageName: packageName).delete();
}

extension QueryPackageExt on Query<(Expr<Package>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Package>,)> byKey({required String packageName}) =>
      where((package) => package.packageName.equalsLiteral(packageName)).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
              Expr<String> packageName,
              Expr<int> likes,
              Expr<int> ownerId,
              Expr<String?> publisher,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        this,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? packageName,
            Expr<int>? likes,
            Expr<int>? ownerId,
            Expr<String?>? publisher,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            packageName,
            likes,
            ownerId,
            publisher,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    String? packageName,
    int? likes,
    int? ownerId,
    String? publisher,
  }) =>
      ExposedForCodeGen.update<Package>(
        this,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          packageName != null ? literal(packageName) : null,
          likes != null ? literal(likes) : null,
          ownerId != null ? literal(ownerId) : null,
          publisher != null ? literal(publisher) : null,
        ]),
      );
}

extension QuerySinglePackageExt on QuerySingle<(Expr<Package>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Package> Function(
            Expr<Package> package,
            Update<Package> Function({
              Expr<String> packageName,
              Expr<int> likes,
              Expr<int> ownerId,
              Expr<String?> publisher,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
        (package) => updateBuilder(
          package,
          ({
            Expr<String>? packageName,
            Expr<int>? likes,
            Expr<int>? ownerId,
            Expr<String?>? publisher,
          }) =>
              ExposedForCodeGen.buildUpdate<Package>([
            packageName,
            likes,
            ownerId,
            publisher,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    String? packageName,
    int? likes,
    int? ownerId,
    String? publisher,
  }) =>
      ExposedForCodeGen.update<Package>(
        asQuery,
        (package) => ExposedForCodeGen.buildUpdate<Package>([
          packageName != null ? literal(packageName) : null,
          likes != null ? literal(likes) : null,
          ownerId != null ? literal(ownerId) : null,
          publisher != null ? literal(publisher) : null,
        ]),
      );
}

extension ExpressionPackageExt on Expr<Package> {
  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 0);

  /// TODO: document likes
  Expr<int> get likes => ExposedForCodeGen.field(this, 1);

  /// TODO: document ownerId
  Expr<int> get ownerId => ExposedForCodeGen.field(this, 2);

  /// TODO: document publisher
  Expr<String?> get publisher => ExposedForCodeGen.field(this, 3);

  /// TODO: document references
  Expr<User?> get owner => ExposedForCodeGen.subqueryTable(
        reference: this,
        tableName: 'users',
        columns: _$User._$fields,
        primaryKey: _$User._$primaryKey,
        deserialize: _$User.new,
      ).where((r) => r.userId.equals(ownerId)).first;
}

final class _$Like extends Like {
  _$Like(RowReader row)
      : userId = row.readInt()!,
        packageName = row.readString()!;

  @override
  final int userId;

  @override
  final String packageName;

  static const _$fields = [
    'userId',
    'packageName',
  ];

  static const _$primaryKey = [
    'userId',
    'packageName',
  ];

  @override
  String toString() => 'Like(userId: "$userId", packageName: "$packageName")';
}

extension TableLikeExt on Table<Like> {
  /// TODO: document create
  Future<Like> create({
    required int userId,
    required String packageName,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          literal(userId),
          literal(packageName),
        ],
      );

  /// TODO: document insert
  Future<Like> insert({
    required Expr<int> userId,
    required Expr<String> packageName,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          userId,
          packageName,
        ],
      );

  /// TODO: document delete
  Future<void> delete({
    required int userId,
    required String packageName,
  }) =>
      byKey(
        userId: userId,
        packageName: packageName,
      ).delete();
}

extension QueryLikeExt on Query<(Expr<Like>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Like>,)> byKey({
    required int userId,
    required String packageName,
  }) =>
      where((like) => like.userId
          .equalsLiteral(userId)
          .and(like.packageName.equalsLiteral(packageName))).first;

  /// TODO: document updateAll()
  Future<void> updateAll(
          Update<Like> Function(
            Expr<Like> like,
            Update<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Like>(
        this,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              ExposedForCodeGen.buildUpdate<Like>([
            userId,
            packageName,
          ]),
        ),
      );

  /// TODO: document updateAllLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateAllLiteral({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update<Like>(
        this,
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );
}

extension QuerySingleLikeExt on QuerySingle<(Expr<Like>,)> {
  /// TODO: document update()
  Future<void> update(
          Update<Like> Function(
            Expr<Like> like,
            Update<Like> Function({
              Expr<int> userId,
              Expr<String> packageName,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Like>(
        asQuery,
        (like) => updateBuilder(
          like,
          ({
            Expr<int>? userId,
            Expr<String>? packageName,
          }) =>
              ExposedForCodeGen.buildUpdate<Like>([
            userId,
            packageName,
          ]),
        ),
      );

  /// TODO: document updateLiteral()
  /// WARNING: This cannot set properties to `null`!
  Future<void> updateLiteral({
    int? userId,
    String? packageName,
  }) =>
      ExposedForCodeGen.update<Like>(
        asQuery,
        (like) => ExposedForCodeGen.buildUpdate<Like>([
          userId != null ? literal(userId) : null,
          packageName != null ? literal(packageName) : null,
        ]),
      );
}

extension ExpressionLikeExt on Expr<Like> {
  /// TODO: document userId
  Expr<int> get userId => ExposedForCodeGen.field(this, 0);

  /// TODO: document packageName
  Expr<String> get packageName => ExposedForCodeGen.field(this, 1);
}

extension QueryOwnerPackageNamed<A, B> on Query<
    ({
      Expr<A> owner,
      Expr<B> package,
    })> {
  Query<(Expr<A>, Expr<B>)> get _asPositionalQuery =>
      ExposedForCodeGen.renamedRecord(
          this,
          (e) => (
                e.owner,
                e.package,
              ));
  static Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> _fromPositionalQuery<A, B>(
          Query<(Expr<A>, Expr<B>)> query) =>
      ExposedForCodeGen.renamedRecord(
          query,
          (e) => (
                owner: e.$1,
                package: e.$2,
              ));
  static T Function(Expr<A> a, Expr<B> b) _wrapBuilder<T, A, B>(
          T Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) e)
              builder) =>
      (a, b) => builder((
            owner: a,
            package: b,
          ));
  Stream<
      ({
        A owner,
        B package,
      })> fetch() async* {
    yield* _asPositionalQuery.fetch().map((e) => (
          owner: e.$1,
          package: e.$2,
        ));
  }

  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> offset(
          int offset) =>
      _fromPositionalQuery(_asPositionalQuery.offset(offset));
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> limit(
          int limit) =>
      _fromPositionalQuery(_asPositionalQuery.limit(limit));
  Query<T> select<T extends Record>(
          T Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) expr)
              projectionBuilder) =>
      _asPositionalQuery.select(_wrapBuilder(projectionBuilder));
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> where(
          Expr<bool> Function(
                  ({
                    Expr<A> owner,
                    Expr<B> package,
                  }) expr)
              conditionBuilder) =>
      _fromPositionalQuery(
          _asPositionalQuery.where(_wrapBuilder(conditionBuilder)));
  Query<
      ({
        Expr<A> owner,
        Expr<B> package,
      })> orderBy<T>(
    Expr<T> Function(
            ({
              Expr<A> owner,
              Expr<B> package,
            }) expr)
        expressionBuilder, {
    bool descending = false,
  }) =>
      _fromPositionalQuery(_asPositionalQuery.orderBy(
        _wrapBuilder(expressionBuilder),
        descending: descending,
      ));
}

extension QueryPackagesTotalLikesUserNameNamed<A, B, C> on Query<
    ({
      Expr<A> packages,
      Expr<B> totalLikes,
      Expr<C> userName,
    })> {
  Query<(Expr<A>, Expr<B>, Expr<C>)> get _asPositionalQuery =>
      ExposedForCodeGen.renamedRecord(
          this,
          (e) => (
                e.packages,
                e.totalLikes,
                e.userName,
              ));
  static Query<
      ({
        Expr<A> packages,
        Expr<B> totalLikes,
        Expr<C> userName,
      })> _fromPositionalQuery<A, B, C>(
          Query<(Expr<A>, Expr<B>, Expr<C>)> query) =>
      ExposedForCodeGen.renamedRecord(
          query,
          (e) => (
                packages: e.$1,
                totalLikes: e.$2,
                userName: e.$3,
              ));
  static T Function(Expr<A> a, Expr<B> b, Expr<C> c) _wrapBuilder<T, A, B, C>(
          T Function(
                  ({
                    Expr<A> packages,
                    Expr<B> totalLikes,
                    Expr<C> userName,
                  }) e)
              builder) =>
      (a, b, c) => builder((
            packages: a,
            totalLikes: b,
            userName: c,
          ));
  Stream<
      ({
        A packages,
        B totalLikes,
        C userName,
      })> fetch() async* {
    yield* _asPositionalQuery.fetch().map((e) => (
          packages: e.$1,
          totalLikes: e.$2,
          userName: e.$3,
        ));
  }

  Query<
      ({
        Expr<A> packages,
        Expr<B> totalLikes,
        Expr<C> userName,
      })> offset(
          int offset) =>
      _fromPositionalQuery(_asPositionalQuery.offset(offset));
  Query<
      ({
        Expr<A> packages,
        Expr<B> totalLikes,
        Expr<C> userName,
      })> limit(
          int limit) =>
      _fromPositionalQuery(_asPositionalQuery.limit(limit));
  Query<T> select<T extends Record>(
          T Function(
                  ({
                    Expr<A> packages,
                    Expr<B> totalLikes,
                    Expr<C> userName,
                  }) expr)
              projectionBuilder) =>
      _asPositionalQuery.select(_wrapBuilder(projectionBuilder));
  Query<
      ({
        Expr<A> packages,
        Expr<B> totalLikes,
        Expr<C> userName,
      })> where(
          Expr<bool> Function(
                  ({
                    Expr<A> packages,
                    Expr<B> totalLikes,
                    Expr<C> userName,
                  }) expr)
              conditionBuilder) =>
      _fromPositionalQuery(
          _asPositionalQuery.where(_wrapBuilder(conditionBuilder)));
  Query<
      ({
        Expr<A> packages,
        Expr<B> totalLikes,
        Expr<C> userName,
      })> orderBy<T>(
    Expr<T> Function(
            ({
              Expr<A> packages,
              Expr<B> totalLikes,
              Expr<C> userName,
            }) expr)
        expressionBuilder, {
    bool descending = false,
  }) =>
      _fromPositionalQuery(_asPositionalQuery.orderBy(
        _wrapBuilder(expressionBuilder),
        descending: descending,
      ));
}
