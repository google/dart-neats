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

import 'package:source_gen/source_gen.dart';

final typedSqlSrcUri = Uri.parse('package:typed_sql/src/typed_sql.dart');

// TODO: Consider, if type checkers could be extension methods!

final schemaTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#Schema'),
);
final modelTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#Model'),
);
final tableTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#Table'),
);
final uniqueTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#Unique'),
);
final autoIncrementTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#AutoIncrement'),
);
final defaultValueTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#DefaultValue'),
);
final referencesTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#References'),
);
final primaryKeyTypeChecker = TypeChecker.fromUrl(
  typedSqlSrcUri.resolve('#PrimaryKey'),
);
final dateTimeTypeChecker = const TypeChecker.fromUrl('dart:core#DateTime');
