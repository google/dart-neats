`package:typed_sql` ships with support for connecting to SQLite3 and PostgreSQL.
A database connection consists of two parts:
 * An `SqlDialect`, which knows how to render SQL queries, and,
 * A `DatabaseAdaptor`, which manages connections to the database.

For convenience, the `DatabaseAdaptor` provides constructors for connecting
test database. When using one of these constructors a temporary database will
be created, and when `close()` called on the `DatabaseAdaptor` the
temporary database will be deleted.

## Testing with SQLite3
The following example shows how to create an in-memory database for testing
with SQLite3:

```dart sqlite_test.dart#testing
import 'package:test/test.dart' show addTearDown, test;
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

void main() {
  test('test with sqlite database', () async {
    final adaptor = DatabaseAdaptor.sqlite3TestDatabase();
    // Always remember to close the adaptor. This will delete the test database!
    addTearDown(adaptor.close);

    final db = Database<BankVault>(adaptor, SqlDialect.sqlite());

    // Create tables in the empty test database
    await db.createTables();

    // ...
  });
}
```

> [!NOTE]
> The [DatabaseAdaptor] for SQLite3 relies on [`package:sqlite3`][sd-1],
> this requires the dynamic library to available on the system, or manually
> specified, see [manually providing sqlite3 libraries][sd-2].

[sd-1]: https://pub.dev/packages/sqlite3
[sd-2]: https://pub.dev/packages/sqlite3#manually-providing-sqlite3-libraries

You can also create an in-memory database using the `DatabaseAdaptor.sqlite3`
constructor, but beware that the `:memory:` URI does not work well, because
`package:typed_sql` may need to create multiple concurrent connections.
See reference documentation for `DatabaseAdaptor.sqlite3` for details.


## Testing with PostgreSQL
The following example shows how to create a temporary database for testing
with PostgreSQL:

```dart postgres_test.dart#testing
import 'package:test/test.dart' show addTearDown, test;
import 'package:typed_sql/typed_sql.dart';

import 'model.dart';

void main() {
  test('test with postgres database', () async {
    final adaptor = DatabaseAdaptor.postgresTestDatabase();
    // Always remember to close the adaptor. This will delete the test database!
    addTearDown(adaptor.close);

    final db = Database<BankVault>(adaptor, SqlDialect.postgres());

    // Create tables in the empty test database
    await db.createTables();

    // ...
  });
}
```

The `DatabaseAdaptor.postgresTestDatabase` will connect to a postgres database,
create a new database, return a `DatabaseAdaptor` connected to the new database,
and delete the database when `close()` is called on the `DatabaseAdaptor`.

For this to work `DatabaseAdaptor.postgresTestDatabase` constructor **must**
connect a postgres database as _administrator_, you can specify connection
parameters directly, but if you don't it assumes a database is accessible using:
 * `$PGHOST`, defaults to `'127.0.0.1'`,
 * `$PGPORT`, defaults to `5432`,
 * `$PGDATABASE`, defaults to `'postgres'`,
 * `$PGUSER`, defaults to `'postgres'`, and,
 * `$PGPASSWORD`, defaults to `'postgres'`.

For testing locally you can spin up such a postgres instance using:
```sh
docker run \
  -ti --rm \
  -e POSTGRES_PASSWORD=postgres \
  -p 127.0.0.1:5432:5432 \
  postgres:17
```

> [!TIP]
> Dart packages may store _internal scripts_ in the [`tool/` folder][dart-1].
> Storing the script above as `tool/launch-test-database.sh` offers a convenient
> way re-launch the postgres instance when it's been terminated.

As the databases used for testing are deleted from the postgres instance, it
should not be necessary to terminate and relaunch the database frequently.

[dart-1]: https://dart.dev/tools/pub/package-layout#internal-tools-and-scripts

For testing on Github Actions you can create a
[PostgreSQL service container][gh-1] as follows:

```yaml
runs-on: ubuntu-latest
services:
  postgres:
    image: postgres:17
    env:
      POSTGRES_PASSWORD: postgres
    options: >-
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
    ports:
      - 5432:5432
steps:
 - ...
```

[gh-1]: https://docs.github.com/en/actions/use-cases-and-examples/using-containerized-services/creating-postgresql-service-containers


## Assertions with `package:checks`
When writing tests we often need to check if the _actual value_ of some variable
matches the _expected value_. [`package:checks`][checks] offers a convenient
mechanism for writing assertions. In the common case, you can do
`check(actual).equals(expected)`, but where `package:checks` excels is when you
want to check a more complicated condition. `check(actual)` has a
number _extension methods_ depending on the type of `actual`. Similarly, to how
`Expr<T>` works in `package:typed_sql`.

These extension methods will let you do things like
`check('hello').length.lessThan(10)`. The various extension methods available
are easy to discover with auto-completion once you've typed `check(actual)`.

When making assertions on custom types with `package:checks` it's often
necessary to extract the property you want to check, or write custom extension
methods for `package:checks`. However, if you import `package:checks` when
defining your database schema (typically in `model.dart`), the code-generator
for `package:typed_sql` will automatically generate extension methods
for your _model classes_.

The following example defines the database schema for a simple bank vault.
Importing `package:checks/checks.dart` will cause the code-generator to output
additional extension methods for `package:checks`.

```dart testing/model.dart#schema-imports
// When `package:checks` is imported, code-generator will create extension
// methods for assertions on rows.
import 'package:checks/checks.dart';
import 'package:typed_sql/typed_sql.dart';

part 'model.g.dart';

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

When we have an instance of `Account` we can now use `check(account)` to make
assertions on said instance. The following example demonstrates how a lookup
by `accountNumber`, which returns `Account?` can be checked.

```dart checks_test.dart#check-account
// Create a new account
await db.accounts.insert(accountNumber: literal('0000-001')).execute();

// Fetch the created account
final account = await db.accounts.byAccountNumber('0000-001').fetch();
// Check that the default balance is not positive
check(account).isNotNull().balance.isLessOrEqual(0);
```

[checks]: https://pub.dev/packages/checks
