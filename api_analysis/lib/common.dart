import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

extension LanguageVersionCompatibilityExt on Pubspec {
  Version get languageVersion {
    final sdk = (environment ?? {})['sdk'];
    if (sdk is VersionRange) {
      final min = sdk.min ?? Version(0, 0, 0);
      return Version(min.major, min.minor, 0);
    }
    // Note: Techincally there are other options
    return Version(0, 0, 0);
  }

  bool get dart3Compatible => languageVersion >= Version(2, 12, 0);
}

extension PackageSchemeExt on Uri {
  /// True, if this [Uri] points to a resource in [package].
  bool isInPackage(String package) =>
      isScheme('package') && pathSegments.firstOrNull == package;
}

/// Thrown when shape analysis fails.
///
/// This typically happens because the Dart code being analyzed is invalid, or
/// because the analysis is unable to handle the code in question.
class ShapeAnalysisException implements Exception {
  final String message;
  ShapeAnalysisException._(this.message);

  @override
  String toString() => message;
}

Never fail(String message) => throw ShapeAnalysisException._(message);
