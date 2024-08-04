// Copyright 2023 Google LLC
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

/// Example of documentation comments and code samples in Dart.

/// code block without specified language
/// ```
/// final result = add(2, 3);
/// print(result); // 5
/// ```
int add(int a, int b) {
  return a + b;
}

/// multiple code blocks
/// ```dart
/// final result = multiply(4, 5);
/// print(result); // 20
/// ```
///
/// ```dart
/// final result = multiply(6, 7);
/// print(result); // 42
/// ```
int multiply(int x, int y) {
  return x * y;
}

/// non-dart code block will be ignored.
///
/// ```python
/// def add(a, b):
///    return a + b
/// ```
///
/// ```yaml
/// dev-dependencies:
///   dartdoc_test: any
/// ```
void ignore() {}

/// you can ignore code sample by using `no-test` tag.
///
/// ```dart
/// // dartdoc_test:ignore_error
///
/// tagIgnore() // it is not reported.
/// ```
void tagIgnore() {}

/// Should return: Expected to find ';'.
/// ```dart
/// final fact = factorial(5)
/// print(fact); // 120
/// ```
int factorial(int n) {
  if (n < 0) throw ArgumentError('Negative numbers are not allowed.');
  return n == 0 ? 1 : n * factorial(n - 1);
}

/// Checks if a string is a palindrome.
///
/// This method ignores case and non-alphanumeric characters.
///
/// Example:
/// ```dart
/// final isPalindrome = isPalindrome('A man, a plan, a canal, Panama');
/// print(isPalindrome); // true
/// ```
bool isPalindrome(String s) {
  var sanitized = s.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toLowerCase();
  return sanitized == sanitized.split('').reversed.join('');
}

/// Should return: Local variable 'gcd' can't be referenced before it is declared.
/// ```dart
/// final gcd = gcd(48, 18);
/// print(gcd); // 6
/// ```
int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % b;
    a = t;
  }
  return a;
}

/// Convert a string to a list of lines.
///
/// This method splits a string into lines using the newline character.
///
/// Example:
/// ```dart
/// final lines = splitLines('Hello\nWorld');
/// print(lines); // ['Hello', 'World']
/// ```
List<String> splitLines(String s) {
  return LineSplitter.split(s).toList();
}
