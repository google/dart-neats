// Copyright 2020 Google LLC
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
import 'package:yaml_edit/src/equality.dart';
import 'package:yaml_edit/src/errors.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Asserts that a string containing a single YAML document is unchanged
/// when dumped right after loading.
void Function() expectLoadPreservesYAML(String source) {
  final doc = YamlEditor(source);
  return () => expect(doc.toString(), equals(source));
}

/// Asserts that [builder] has the same internal value as [expected].
void expectYamlBuilderValue(YamlEditor builder, Object expected) {
  final builderValue = builder.parseAt([]);
  expectDeepEquals(builderValue, expected);
}

/// Asserts that [builder] has the same internal value as [expected].
void expectDeepEquals(Object? actual, Object expected) {
  expect(
      actual, predicate((actual) => deepEquals(actual, expected), '$expected'));
}

Matcher notEquals(dynamic expected) => isNot(equals(expected));

/// A matcher for functions that throw [PathError].
Matcher throwsPathError = throwsA(isA<PathError>());

/// A matcher for functions that throw [AliasError].
Matcher throwsAliasError = throwsA(isA<AliasError>());

/// Enum to hold the possible modification methods.
enum YamlModificationMethod {
  appendTo,
  insert,
  prependTo,
  remove,
  splice,
  update,
}
