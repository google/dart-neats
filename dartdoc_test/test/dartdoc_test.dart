import 'package:dartdoc_test/dartdoc_test.dart';

/// Test code samples in documentation comments in this package.
///
/// It extracts code samples from documentation comments in this package and
/// analyzes them. If there are any errors in the code samples, the test will fail
/// and you can see the problems details.
///
/// If you want to test only specific files, you can use [exclude] option.
void main() => runDartdocTest(
      exclude: ['example/**'],
    );
