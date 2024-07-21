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

/// This is a simple class example.
///
/// This class demonstrates a simple Dart class with a single method.
class SimpleClass {
  /// Adds two numbers together.
  ///
  /// The method takes two integers [a] and [b], and returns their sum.
  ///
  /// Example:
  /// ```
  /// final result = SimpleClass().add(2, 3)  //
  /// print(result); // 5
  /// ```
  int add(int a, int b) {
    return a + b;
  }
}

/// This class demonstrates more complex documentation comments,
/// including parameter descriptions and a detailed method explanation.
class ComplexClass {
  /// Multiplies two numbers together.
  ///
  /// Takes two integers [x] and [y], multiplies them and returns the result.
  /// This method handles large integers and ensures no overflow occurs.
  ///
  /// Example:
  /// ```dart
  /// final product = ComplexClass().multiply(4, 5);
  /// print(product); // 20
  /// ```
  int multiply(int x, int y) {
    return x * y;
  }

  /// Calculates the factorial of a number.
  ///
  /// This method uses a recursive approach to calculate the factorial of [n].
  /// It throws an [ArgumentError] if [n] is negative.
  ///
  /// Example:
  /// ```dart
  /// final fact = ComplexClass().factorial(5);
  /// print(fact); // 120
  /// ```
  ///
  /// Throws:
  /// - [ArgumentError] if [n] is negative.
  int factorial(int n) {
    if (n < 0) throw ArgumentError('Negative numbers are not allowed.');
    return n == 0 ? 1 : n * factorial(n - 1);
  }
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

/// Calculates the greatest common divisor (GCD) of two numbers.
///
/// Uses the Euclidean algorithm to find the GCD of [a] and [b].
///
/// Example1:
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

void main() {
  // Test cases to validate the functionality and documentation of the methods.

  // SimpleClass tests
  final simple = SimpleClass();
  assert(simple.add(2, 3) == 5);

  // ComplexClass tests
  final complex = ComplexClass();
  assert(complex.multiply(4, 5) == 20);
  assert(complex.factorial(5) == 120);

  assert(isPalindrome('A man, a plan, a canal, Panama'));
  assert(gcd(48, 18) == 6);
  assert(splitLines('Hello\nWorld') == ['Hello', 'World']);

  print('All tests passed!');
}
