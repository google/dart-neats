This document shows how to do transactions with `package:typed_sql`.
Examples throughout this document assume a database schema defined as
follows:

```dart bank_test.dart#schema
abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Model {
  @AutoIncrement()
  int get accountId;

  @Unique()
  String get accountNumber;

  @DefaultValue(0.0)
  double get balance;
}
```

Similarly, examples in this document will assume that the database is loaded
with the following examples:
```dart bank_test.dart#initial-data
final initialAccounts = [
  (accountNumber: '0001', balance: 100.0),
  (accountNumber: '0002', balance: 200.0),
  (accountNumber: '0003', balance: 300.0),
];
```

## Use a transaction to update multiple rows
If we want to transfer 100 from account `0001` to account `0002`, we can use
`db.transact` to do two updates in a single transaction, as illustrated in the
following example:

```dart bank_test.dart#transfer-100
await db.transact(() async {
  // Withdraw 100 from account 0000-01
  await db.accounts
      .byAccountNumber('0001')
      .update((a, set) => set(balance: a.balance - literal(100)))
      .execute();

  // Deposit 100 to account 0000-02
  await db.accounts
      .byAccountNumber('0002')
      .update((a, set) => set(balance: a.balance + literal(100)))
      .execute();
});
```

Either both updates in the transaction will be committed, or neither will be
committed. In an accounting system this ensures that money isn't withdrawn from
one account without being deposited into another.

> [!NOTE]
> Whether or not a two concurrent transaction can see uncommitted mutations from
> eachother depends on the [transaction isolation level][1] of the underlying
> SQL database. See documentation (and configuration options) for your database.


## Abort and rollback a transaction
If we want to abort and rollback a transaction we simply throw an `Exception`
(or `Error`) inside the `db.transact` callback. Then `db.transact` will rollback
the transaction and throw an `TransactionAbortedException` wrapping the
`Exception` that caused the transaction to be aborted.

The following example demonstrates how we can abort a transaction, if the
balance of account `0001` is insufficient to complete the transfer.

```dart bank_test.dart#transfer-100-with-rollback
try {
  await db.transact(() async {
    // Withdraw 100 from account 0000-01
    final newBalance = await db.accounts
        .byAccountNumber('0001')
        .update((a, set) => set(balance: a.balance - literal(100)))
        .returning((a) => (a.balance,))
        .executeAndFetch();
    if (newBalance == null) {
      throw AccountNotFoundException();
    }
    if (newBalance < 0) {
      // If balance is negative we throw an Exception to rollback the
      // transaction
      throw InsufficientBalanceException();
    }

    // Deposit 100 to account 0000-02
    await db.accounts
        .byAccountNumber('0002')
        .update((a, set) => set(balance: a.balance + literal(100)))
        .execute();
  });
} on TransactionAbortedException catch (e) {
  switch (e.reason) {
    case InsufficientBalanceException():
      print('Transfer was aborted due to insufficient balance');
    case AccountNotFoundException():
      print('Transfer was aborted as account was not found');
    default:
      rethrow;
  }
}
```

We could also have made the `.update` conditional using `.where` and returned
from the transaction before making the deposit into `0002`. This might feel
more natural, and be slightly more convenient than try/throw and catch.
However, as illustrated in the example below it's hard to know if the update
failed because the account wasn't found or because the balance was insufficient.

```dart bank_test.dart#transfer-100-with-conditional-update
await db.transact(() async {
  // Withdraw 100 from account 0000-01
  final newBalance = await db.accounts
      .byAccountNumber('0001')
      .where((a) => a.balance >= literal(100))
      .update((a, set) => set(balance: a.balance - literal(100)))
      .returning((a) => (a.balance,))
      .executeAndFetch();
  if (newBalance == null) {
    print('account not found or insufficient balance');
    return;
  }

  // Deposit 100 to account 0000-02
  await db.accounts
      .byAccountNumber('0002')
      .update((a, set) => set(balance: a.balance + literal(100)))
      .execute();
});
```

In practice, it's probably more natural to lookup the balance prior to making
the update. This incurs additional database round-trips, and using a database
configured without a strict [transaction isolation][1] this could lead to
inconsistencies.


## Nested transactions
While SQL doesn't have nested transactions, SQL does have `SAVEPOINT`s which can
be used to facilitate nested transactions. Using `package:typed_sql` you can do
nested invocations of `db.transact()`. The outer most invocation will create a
and transaction, and the nested invocations will create a unique `SAVEPOINT`
for each invocation.

This makes it possible to recover from an aborted transaction which may occur if
you violate a constraint. The follow example shows how to insert account `0002`
and recover, if the transaction is aborted.

```dart bank_test.dart#insert-or-update-using-nested-transaction
await db.transact(() async {
  await db.accounts
      .byAccountNumber('0001')
      .update((a, set) => set(balance: a.balance - literal(100)))
      .execute();

  try {
    await db.transact(() async {
      await db.accounts
          .insert(
            accountNumber: literal('0002'),
            balance: literal(100),
          )
          .execute();
    });
  } on TransactionAbortedException {
    await db.accounts
        .byAccountNumber('0002')
        .update((a, set) => set(balance: a.balance + literal(100)))
        .execute();
  }
});
```

> [!WARNING]
> Nested transaction can be hard to use correctly, often you're probably better
> off trying to avoid nested transaction. In the example above, it would
> probably better to use two separate transactions, first attempting to update
> and if that fails (or there is nothing to update), then trying to insert a
> new row in the accounts table.


## Pitfalls with transactions
There are a few limitations and pitfalls when using transactions with
`package:typed_sql`. The most important thing to remember to always `await`
operations and transactions, in particularly operations inside transactions.

The `db.transact(cb)` method will start a transaction and execute the callback
`cb` inside a [Zone], such that all operations using `db` happens inside the
transaction. When the callback `cb` completes (or rather the future `cb`
returns is completes), the transaction is committed (or rolledback if `cb`
threw an `Exception`). So if we were to additional calls on `db` inside the
transaction zone, they would throw errors at runtime, example:

```dart
await db.transact(() async {
  await db.byAccountNumber('0001').delete().execute();
  //▲
  //└──────── Always add 'await' as illustrated here.

  /***/ db.byAccountNumber('0002').delete().execute();
  //▲
  //└─────── Missing await here is VERY BAD, may cause a runtime error!
});
```

Even if you don't care about whether or not the operation is successful,
you must **always `await` operations in transactions**.
Similarly, you must also `await` nested transactions.

Furthermore, to prevent deadlocks in transaction callbacks `Query<T>.stream()`
will not pause on back-pressure inside transactions. This means that
_inside a transaction_ it doesn't matter if you use `Query<T>.stream()` or
`Query<T>.fetch()`. In both cases, all the result-rows may be buffered in
memory.

> [!TIP]
> If you find yourself hitting memory limits because `.stream()` inside a
> transaction buffers up all the result-rows, then you should probably consider
> making smaller transactions. A transaction covering many rows is also likely
> to lock up the database and make concurrent transactions / queries
> problematic.

Finally, you cannot initated queries or operations that don't run in the
transaction from inside the _transaction callback_. That's because `db` will
lookup the current transaction (if any) from a zone variable. This is rarely a
limitation, in practice you can just execute such queries before starting the
transaction. Mostly, this serves to prevent you from starting a transaction and
then accidentally execute operations/queries outside the transaction context.


[1]: https://en.wikipedia.org/wiki/Isolation_(database_systems)
[Zone]: https://api.dart.dev/stable/latest/dart-async/Zone-class.html

