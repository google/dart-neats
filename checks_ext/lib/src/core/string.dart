// Copyright 2026 Google LLC
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

import 'dart:convert';
import '../util.dart';

extension StringChecksExt on Subject<String> {
  /// Expects that the string is empty or contains only whitespace.
  ///
  /// {@example /example/core/string/is_blank.dart}
  void isBlank() {
    context.expect(() => ['is blank'], (actual) {
      if (actual.trim().isNotEmpty) {
        return Rejection(which: ['was not blank']);
      }
      return null;
    });
  }

  /// Expects that the string is not empty and contains at least one non-whitespace character.
  ///
  /// {@example /example/core/string/is_not_blank.dart}
  void isNotBlank() {
    context.expect(() => ['is not blank'], (actual) {
      if (actual.trim().isEmpty) {
        return Rejection(which: ['was blank']);
      }
      return null;
    });
  }

  /// Extracts the lines of the string.
  ///
  /// {@example /example/core/string/lines.dart}
  Subject<Iterable<String>> get lines => context.nest(
    () => ['has lines'],
    (actual) => Extracted.value(const LineSplitter().convert(actual)),
  );

  /// Expects that all alphabetic characters in the string are lowercase.
  ///
  /// {@example /example/core/string/is_lower_case.dart}
  void isLowerCase() {
    context.expect(() => ['is lower case'], (actual) {
      if (actual != actual.toLowerCase()) {
        return Rejection(which: ['was not lower case']);
      }
      return null;
    });
  }

  /// Expects that all alphabetic characters in the string are uppercase.
  ///
  /// {@example /example/core/string/is_upper_case.dart}
  void isUpperCase() {
    context.expect(() => ['is upper case'], (actual) {
      if (actual != actual.toUpperCase()) {
        return Rejection(which: ['was not upper case']);
      }
      return null;
    });
  }

  /// Expects that the string starts with an uppercase letter.
  ///
  /// {@example /example/core/string/is_capitalized.dart}
  void isCapitalized() {
    context.expect(() => ['is capitalized'], (actual) {
      if (actual.isEmpty) {
        return Rejection(which: ['is empty']);
      }
      final firstChar = actual.substring(0, 1);
      if (firstChar != firstChar.toUpperCase()) {
        return Rejection(which: ['first character was not upper case']);
      }
      return null;
    });
  }

  /// Expects that the string contains only digits.
  ///
  /// {@example /example/core/string/is_numeric.dart}
  void isNumeric() {
    context.expect(() => ['is numeric'], (actual) {
      if (!RegExp(r'^\d+$').hasMatch(actual)) {
        return Rejection(which: ['contains non-numeric characters']);
      }
      return null;
    });
  }

  /// Expects that the string contains only letters.
  ///
  /// {@example /example/core/string/is_alpha.dart}
  void isAlpha() {
    context.expect(() => ['is alpha'], (actual) {
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(actual)) {
        return Rejection(which: ['contains non-alphabetic characters']);
      }
      return null;
    });
  }

  /// Expects that the string contains only letters and digits.
  ///
  /// {@example /example/core/string/is_alphanumeric.dart}
  void isAlphanumeric() {
    context.expect(() => ['is alphanumeric'], (actual) {
      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(actual)) {
        return Rejection(
          which: ['contains characters that are not letters or digits'],
        );
      }
      return null;
    });
  }

  /// Expects that the string contains [expected] ignoring case.
  ///
  /// {@example /example/core/string/contains_ignoring_case.dart}
  void containsIgnoringCase(String expected) {
    context.expect(
      () => prefixFirst('contains ignoring case ', literal(expected)),
      (actual) {
        if (!actual.toLowerCase().contains(expected.toLowerCase())) {
          return Rejection(
            which: [
              ...prefixFirst(
                'does not contain ',
                postfixLast(' (case-insensitive)', literal(expected)),
              ),
            ],
          );
        }
        return null;
      },
    );
  }
}
