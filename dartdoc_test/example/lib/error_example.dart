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

/// Should return: The getter 'length' isn't defined for the class 'int'.
/// ```dart
/// final length = 5.length;
/// print(length); // 1
/// ```
void length() {}
