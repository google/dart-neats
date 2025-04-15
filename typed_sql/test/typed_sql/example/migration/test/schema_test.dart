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

import 'package:test/test.dart';
// ignore: avoid_relative_lib_imports
import '../lib/model.dart';

void main() {
  test('bin/schema.dart', () {
    expect(
        createBankVaultTables(SqlDialect.sqlite()), equalsIgnoringWhitespace('''
CREATE TABLE "accounts" (
  "accountId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "accountNumber" TEXT NOT NULL,
  UNIQUE ("accountNumber")
);
'''));
  });
}
