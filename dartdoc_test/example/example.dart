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
  /// final result = SimpleClass().add(2, 3);
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
/// final isPalindrome = Utility.isPalindrome('A man, a plan, a canal, Panama');
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
/// final gcd = Utility.gcd(48, 18);
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

void main() {
  // Test cases to validate the functionality and documentation of the methods.

  // SimpleClass tests
  final simple = SimpleClass();
  assert(simple.add(2, 3) == 5);

  // ComplexClass tests
  final complex = ComplexClass();
  assert(complex.multiply(4, 5) == 20);
  assert(complex.factorial(5) == 120);

  // Utility tests
  assert(isPalindrome('A man, a plan, a canal, Panama'));
  assert(gcd(48, 18) == 6);

  print('All tests passed!');
}
