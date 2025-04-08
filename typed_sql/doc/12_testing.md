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

    final db = Database<Bookstore>(adaptor, SqlDialect.sqlite());

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

    final db = Database<Bookstore>(adaptor, SqlDialect.postgres());

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

