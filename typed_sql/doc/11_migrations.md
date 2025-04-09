This document shows how to export the _database schema_ and manage migrations
with external tools such as [atlas].

Traditionally, database migrations are managed with a set of _migration files_.
Where each _migration file_ contains [_Data Definition Language_][DDL]
statements modifying the database schema. Then a migration tool is used to
ensure that migations are applied in order, and that migrations are not applied
more than once. Many migration tools require you to write the _migration file_,
whenever you want to change the database schema.

`package:typed_sql` does not generate, manage or execute database migrations,
you must do that yourself. While it's possible that future versions of
`package:typed_sql` may include such facilities, complex database migrations in
production environments will probably always require manual review.

For this reason, `package:typed_sql` focuses on type-safe queries in Dart, and
leaves management of database migrations to dedicated tools.

## Extracting the database schema
While `package:typed_sql` doesn't manage database migrations it is capable of
creating empty tables as defined in your _database schema_. It is also capable
of producing the [_Data Definition Language_][DDL] statements required to create
the empty database tables.

If define our _database schema_ in a `model.dart` file as illustrated below,
the code-generator for `package:typed_sql` will generate a top-level
`createBankVaultTables(SqlDialect dialect)` function, which given an
`SqlDialect` will return [DDL] statements separated by `;`.

```dart migration/lib/model.dart#schema
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
}
```

Thus, using the generated `createBankVaultTables` we can create a
`bin/schema.dart`, which will print the [DDL] statements to creating the tables.
If we target SQLite3, we can create `bin/schema.dart` as follows:

```dart migration/bin/schema.dart#print-schema
import '../lib/model.dart';

void main() {
  final ddl = createBankVaultTables(SqlDialect.sqlite());
  print(ddl);
}
```

This will print the following `CREATE TABLE` statments:

```sql
CREATE TABLE accounts (
  accountId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  accountNumber TEXT NOT NULL,
  UNIQUE (accountNumber)
);
```

How you wish to create, manage and apply migrations is entirely up to you. But
you should make sure that the database schema looks as it would have looked if
the [DDL] statements from `createBankVaultTables` were executed in an empty
database.


## Managing migrations with `atlas`
There are many database migration management tools to pick from, `atlas` is
merely one of them. Some migration tools focus squarely on how to manage, test
and apply the migrations, while others like [atlas] can also generate migration
files for you.

The following sections demonstrates how to generate, validate and apply
migrations with [atlas _community edition_][atlas-ce]. And assumes that this
has been installed as `atlas` in the current environment.

### Configuration with `atlas.hcl`
The `atlas` tool needs to access the _database schema_, for this we can use
the previously created `bin/schema.dart` file, and write the [DDL] statements
to a file with `dart bin/schema.dart > schema.sql`. Then for SQLite we can
configure `atlas` using an `atlas.hcl` file as follows:

```yaml
# atlas.hcl
env "typed_sql" {
  # File containing the database schema as SQL DLL statements
  src = "file://schema.sql"
  # Development database to use
  dev = "sqlite://dev?mode=memory"
  # Production database to modify when applying migrations
  url = "sqlite://database.db"
  migration {
    # Location where migration files will be stored
    dir    = "file://migrations"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}

lint {
  latest = 1
  non_linear {
    error = true
  }
  data_depend {
    error = true
  }
}
```

You may change the _migration format_ or _lint options_ as you see fit.
Similarly, if you're not targeting SQLite you will need to adjust the
configuration accordingly.

> [!TIP]
> If you are not using the _community edition_ of `atlas` you can use
> `external_schema` to load the schema without writing it to a `schema.sql` file
> first, see `atlas` documentation on [external integrations][atlas-external].
>
> Using the _community edition_ which doesn't support `external_schema`, we'll
> need to run `dart bin/schema.dart > schema.sql` whenever the schema changes.


### Generating an initial migration
With configuration in place we can now generate a migration file using:
```sh
atlas migrate diff --env typed_sql <migration-name>
```

Where `<migration-name>` is the name of the migration. Naming migrations is not
strictly required, _migration files_ are always prefixed by a timestamp to
ensure that they are ordered chronologically. But suffixing the migration files
with an appropriate name can make it easier to review later.

To generate an initial migration, we can run the following commands:
```sh
dart bin/schema.dart > schema.sql # if not using external_schema
atlas migrate diff --env typed_sql initial
```

This will generate two files:
 * `migrations/<timestamp>_initial.sql`, the migration file for the initial
   migration.
 * `migrations/atlas.sum`, a checksum of migration files maintained by `atlas`
   to enforce a _linear migration history_, see `atlas` documentation on
   [migration directory integrity][atlas-sum] for details.

With the `BankVault` database schema we've previously defined, the
`migrations/<timestamp>_initial.sql` will look something like:

```sql
-- Create "accounts" table
CREATE TABLE `accounts` (
  `accountId` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `accountNumber` text NOT NULL
);
-- Create index "accounts_accountNumber" to table: "accounts"
CREATE UNIQUE INDEX `accounts_accountNumber` ON `accounts` (`accountNumber`);
```

### Updating the database schema
Whenever you modify the database schema you must run code-generation with
`build_runner`, if using using `atlas` for migrations you must create a new
_migration file_ using `atlas migrate diff`. Suppose we updated our `BankVault`,
by adding a `balance` column to the `accounts` table, as follows:

```dart migration/lib/patched_model.dart#schema
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

We would now run the following commands to generate a _migration file_:

```sh
dart run build_runner build
dart bin/schema.dart > schema.sql # if not using external_schema
atlas migrate diff --env typed_sql add_balance
```

In our example this will generate a new _migration file_ called
`migrations/<timestamp>_add_balance.sql` that looks like:

```sql
-- Add column "balance" to table: "accounts"
ALTER TABLE `accounts` ADD COLUMN `balance` real NOT NULL DEFAULT 0.0;
```

> [!WARNING]
> While tools like [atlas] can generate _migration files_ for you, it is
> advicible that you manually review the migrations before you apply them in
> a production environment.


### Validating and linting migrations
The `atlas` tool provides some mechanisms for validation and linting of
_migration files_, you simply run:

```sh
atlas migrate validate --env typed_sql
atlas migrate lint --env typed_sql
```

These commands can be used to ensure that migrations can be applied
chronologically, that the migration history is linear and that configured lints
are satisfied. See `atlas` documentation on
[verifying migration safety][atlas-lint].


### Applying migrations
Using the `atlas` tool you can inspect migration status with:
```sh
atlas migrate status --env typed_sql
```

And apply migrations with:
```sh
atlas migrate apply --env typed_sql
```

See `atlas` documentation on [applying migrations][atlas-apply] for details.


[atlas]: https://atlasgo.io/
[atlas-ce]: https://atlasgo.io/community-edition
[atlas-external]: https://atlasgo.io/atlas-schema/external
[atlas-sum]: https://atlasgo.io/concepts/migration-directory-integrity
[atlas-lint]: https://atlasgo.io/versioned/lint
[atlas-apply]: https://atlasgo.io/versioned/apply
[DDL]: https://en.wikipedia.org/wiki/Data_definition_language
