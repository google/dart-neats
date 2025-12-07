// Copyright 2025 Google LLC
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

// #region schema-imports
// When `package:checks` is imported, code-generator will create extension
// methods for assertions on rows.
import 'package:checks/checks.dart';
import 'package:typed_sql/typed_sql.dart';

part 'model.g.dart';

abstract final class BankVault extends Schema {
  Table<Account> get accounts;
}

@PrimaryKey(['accountId'])
abstract final class Account extends Row {
  @AutoIncrement()
  int get accountId;

  @Unique.field()
  @SqlOverride(dialect: 'mysql', columnType: 'VARCHAR(255)') // #hide
  String get accountNumber;

  @DefaultValue(0.0)
  double get balance;
}
// #endregion
