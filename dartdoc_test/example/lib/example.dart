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

/// Examples of documentation comments and code samples in Dart.
///
/// Dart code block will be analyzed by dartdoc_test.
///
/// ```dart
/// final result = add(2, 3);
/// print(result); // 5
/// ```
int add(int a, int b) {
  return a + b;
}

/// If you don't specify the language for code blocks, it still be analyzed.
///
/// ```
/// final result = subtract(5, 3);
/// print(result); // 2
/// ```
int subtract(int x, int y) {
  return x - y;
}

/// Multiple code blocks are also analyzed.
///
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

/// Non-Dart code blocks are ignored.
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

/// You can ignore a code sample by using `no-test` tag.
///
/// ```dart#no-test
/// tagIgnore() // it is not reported.
/// ```
void tagIgnore() {}

/// by default, code samples will be wrapped by `main()` function and analyzed.
/// However, If code sample has `main()` function, it will be not wrapped by `main()`
/// function and analyzed as it is.
///
/// ```dart
/// void main() {
///   final result = divide(10, 2);
///   print(result); // 5
/// }
/// ```
int divide(int x, int y) {
  return x ~/ y;
}

/// When dartdoc_test analyze the code sample, it uses the imports of the file
/// where the code sample is located by default.
/// Also, you can import some libraries and use them in code samples.
/// but you need to add main() function to run the code when you add imports customly.
///
/// ```dart
/// import 'dart:convert';
///
/// void main() {
///   final x = LineSplitter().convert('2\n3').map(int.parse).toList();
///   print(pow(x[0], x[1])); // 8
/// }
/// ```
int pow(int x, int y) {
  return x ^ y;
}
