// Copyright 2019 Google LLC
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

import 'package:petitparser/petitparser.dart';

/// Write all strings in [value] to [target], assuming [value] is a nested
/// list of string of arbitrary finite depth.
void _flattenString(dynamic value, StringBuffer target) {
  if (value == null) {
    return;
  }
  if (value is String) {
    target.write(value);
    return;
  }
  if (value is List) {
    for (final v in value) {
      _flattenString(v, target);
    }
    return;
  }
  throw ArgumentError('Unsupported type ${value.runtimeType}');
}

/// Create a [Parser] that ignores output from [p] and return `null`.
Parser<String?> ignore<T>(Parser<T> p) => p.map((_) => null);

/// Create a [Parser] that flattens all strings in the result from [p].
Parser<String> flatten(Parser<dynamic> p) => p.map((value) {
      final s = StringBuffer();
      _flattenString(value, s);
      return s.toString();
    });
