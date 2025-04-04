// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

extension BankVaultSchema on Database<BankVault> {
  static const _$tables = [_$Account._$table];

  /// TODO: Propagate documentation for tables!
  Table<Account> get accounts => ExposedForCodeGen.declareTable(
        this,
        _$Account._$table,
      );
  Future<void> createTables() async => ExposedForCodeGen.createTables(
        context: this,
        tables: _$tables,
      );
}

String createBankVaultTables(SqlDialect dialect) =>
    ExposedForCodeGen.createTableSchema(
      dialect: dialect,
      tables: BankVaultSchema._$tables,
    );

final class _$Account extends Account {
  _$Account._(
    this.accountId,
    this.accountNumber,
    this.balance,
  );

  @override
  final int accountId;

  @override
  final String accountNumber;

  @override
  final double balance;

  static const _$table = (
    tableName: 'accounts',
    columns: <String>['accountId', 'accountNumber', 'balance'],
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
      ),
      (
        type: ExposedForCodeGen.real,
        isNotNull: true,
        defaultValue: 0.0,
        autoIncrement: false,
      )
    ],
    primaryKey: <String>['accountId'],
    unique: <List<String>>[
      ['accountNumber']
    ],
    foreignKeys: <({
      String name,
      List<String> columns,
      String referencedTable,
      List<String> referencedColumns,
    })>[],
    readModel: _$Account._$fromDatabase,
  );

  static Account? _$fromDatabase(RowReader row) {
    final accountId = row.readInt();
    final accountNumber = row.readString();
    final balance = row.readDouble();
    if (accountId == null && accountNumber == null && balance == null) {
      return null;
    }
    return _$Account._(accountId!, accountNumber!, balance!);
  }

  @override
  String toString() =>
      'Account(accountId: "$accountId", accountNumber: "$accountNumber", balance: "$balance")';
}

extension TableAccountExt on Table<Account> {
  /// TODO: document insert
  InsertSingle<Account> insert({
    Expr<int>? accountId,
    required Expr<String> accountNumber,
    Expr<double>? balance,
  }) =>
      ExposedForCodeGen.insertInto(
        table: this,
        values: [
          accountId,
          accountNumber,
          balance,
        ],
      );

  /// TODO: document delete
  DeleteSingle<Account> delete({required int accountId}) =>
      ExposedForCodeGen.deleteSingle(
        byKey(accountId: accountId),
        _$Account._$table,
      );
}

extension QueryAccountExt on Query<(Expr<Account>,)> {
  /// TODO: document lookup by PrimaryKey
  QuerySingle<(Expr<Account>,)> byKey({required int accountId}) =>
      where((account) => account.accountId.equalsLiteral(accountId)).first;

  /// TODO: document update()
  Update<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
              Expr<double> balance,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.update<Account>(
        this,
        _$Account._$table,
        (account) => updateBuilder(
          account,
          ({
            Expr<int>? accountId,
            Expr<String>? accountNumber,
            Expr<double>? balance,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
            balance,
          ]),
        ),
      );

  /// TODO: document byXXX()}
  QuerySingle<(Expr<Account>,)> byAccountNumber(String accountNumber) =>
      where((account) => account.accountNumber.equalsLiteral(accountNumber))
          .first;

  /// TODO: document delete()}
  Delete<Account> delete() => ExposedForCodeGen.delete(this, _$Account._$table);
}

extension QuerySingleAccountExt on QuerySingle<(Expr<Account>,)> {
  /// TODO: document update()
  UpdateSingle<Account> update(
          UpdateSet<Account> Function(
            Expr<Account> account,
            UpdateSet<Account> Function({
              Expr<int> accountId,
              Expr<String> accountNumber,
              Expr<double> balance,
            }) set,
          ) updateBuilder) =>
      ExposedForCodeGen.updateSingle<Account>(
        this,
        _$Account._$table,
        (account) => updateBuilder(
          account,
          ({
            Expr<int>? accountId,
            Expr<String>? accountNumber,
            Expr<double>? balance,
          }) =>
              ExposedForCodeGen.buildUpdate<Account>([
            accountId,
            accountNumber,
            balance,
          ]),
        ),
      );

  /// TODO: document delete()
  DeleteSingle<Account> delete() =>
      ExposedForCodeGen.deleteSingle(this, _$Account._$table);
}

extension ExpressionAccountExt on Expr<Account> {
  /// TODO: document accountId
  Expr<int> get accountId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document accountNumber
  Expr<String> get accountNumber =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document balance
  Expr<double> get balance =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);
}

extension ExpressionNullableAccountExt on Expr<Account?> {
  /// TODO: document accountId
  Expr<int?> get accountId =>
      ExposedForCodeGen.field(this, 0, ExposedForCodeGen.integer);

  /// TODO: document accountNumber
  Expr<String?> get accountNumber =>
      ExposedForCodeGen.field(this, 1, ExposedForCodeGen.text);

  /// TODO: document balance
  Expr<double?> get balance =>
      ExposedForCodeGen.field(this, 2, ExposedForCodeGen.real);
}

extension AccountChecks on Subject<Account> {
  Subject<int> get accountId => has((m) => m.accountId, 'accountId');
  Subject<String> get accountNumber =>
      has((m) => m.accountNumber, 'accountNumber');
  Subject<double> get balance => has((m) => m.balance, 'balance');
}
