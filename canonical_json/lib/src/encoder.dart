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

import 'dart:convert' show Converter, ascii, utf8;
import 'dart:typed_data' show Uint8List;
import 'package:typed_data/typed_data.dart' show Uint8Buffer;
import 'utils.dart' show char, RawMapEntry;
import 'fast_unorm.dart' show fastNfc;

class CanonicalJsonEncoder extends Converter<Object?, Uint8List> {
  @override
  Uint8List convert(Object? input) {
    final result = Uint8Buffer();
    _encode(result, input, input);
    return Uint8List.view(result.buffer, 0, result.length);
  }
}

void _encode(Uint8Buffer output, Object? input, Object? original) {
  // Handle null, true, false
  if (input == null) {
    output.addAll(ascii.encode('null'));
    return;
  }
  if (input == true) {
    output.addAll(ascii.encode('true'));
    return;
  }
  if (input == false) {
    output.addAll(ascii.encode('false'));
    return;
  }

  // Handle strings, but always encoding to UTF-8 in Unicode Normalization Form
  // C with quotes and backspaces escaped.
  if (input is String) {
    final s = fastNfc(input).replaceAll(r'\', r'\\').replaceAll('"', r'\"');
    output.add(char('"'));
    output.addAll(utf8.encode(s));
    output.add(char('"'));
    return;
  }

  // Handle integers, throw if number is not an integer.
  if (input is num) {
    if (input.toInt() != input) {
      throw ArgumentError.value(
          original,
          'input',
          'canonical_json does not support encoding floats, input '
              'contained "$input"');
    }
    if (input.isNegative && input == 0) {
      throw ArgumentError.value(original, 'input',
          'The float -0.0 cannot be encoded in a canonial json');
    }
    output.addAll(ascii.encode(input.toString()));
    return;
  }

  // Handle lists by calling recursively.
  if (input is List<Object?>) {
    output.add(char('['));
    for (var i = 0; i < input.length; i++) {
      if (i > 0) {
        output.add(char(','));
      }
      _encode(output, input[i], original);
    }
    output.add(char(']'));
    return;
  }

  // Handle maps from string to anything.
  if (input is Map<String, Object?>) {
    final entries = RawMapEntry.fromMap(input).toList();
    entries.sort(RawMapEntry.compare);
    output.add(char('{'));
    var first = true;
    for (final entry in entries) {
      if (!first) {
        output.add(char(','));
      }
      first = false;
      output.addAll(entry.key);
      output.add(char(':'));
      _encode(output, entry.value, original);
    }
    output.add(char('}'));
    return;
  }

  // If not handled yet, throw an exception.
  throw ArgumentError.value(
      original,
      'input',
      'canonical_json can only encode int, string, bool, list and maps, input '
          'contained type: "${input.runtimeType}"');
}
