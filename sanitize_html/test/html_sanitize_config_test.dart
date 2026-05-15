import 'package:sanitize_html/src/html_sanitize_config.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlSanitizeConfig', () {
    test('allowedElements should not contain forbiddenTags', () {
      for (final tag in HtmlSanitizeConfig.forbiddenTags) {
        expect(
          HtmlSanitizeConfig.allowedElements.contains(tag),
          false,
          reason: 'Tag $tag must not appear in allowedElements',
        );
      }
    });

    test('safe id regex matches correctly', () {
      expect(HtmlSanitizeConfig.safeIdPattern.hasMatch('abc123'), true);
      expect(HtmlSanitizeConfig.safeIdPattern.hasMatch('-invalid'), false);
      expect(HtmlSanitizeConfig.safeIdPattern.hasMatch('A_valid.id'), true);
    });

    test('safe class regex matches correctly', () {
      expect(HtmlSanitizeConfig.safeClassPattern.hasMatch('hello'), true);
      expect(HtmlSanitizeConfig.safeClassPattern.hasMatch('9abc'), false);
      expect(HtmlSanitizeConfig.safeClassPattern.hasMatch('class_name'), true);
    });

    group('unicodeEscapeReg', () {
      // The regex requires 3+ consecutive \XX sequences so that single
      // backslash-hex pairs in plain text (e.g. PHP namespace separators)
      // are not false-positives, while meaningful obfuscation is still caught.

      test('does NOT match a single \\XX sequence', () {
        // e.g. \DA from a PHP namespace like \DAV
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\DA'), false);
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\ab'), false);
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\FF'), false);
      });

      test('does NOT match two consecutive \\XX sequences', () {
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\6a\73'), false);
      });

      test('DOES match three or more consecutive \\XX sequences', () {
        // \73\72\63 encodes "src" — still caught
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\73\72\63'), true);
        // \6a\61\76 encodes "jav" — prefix of "javascript"
        expect(HtmlSanitizeConfig.unicodeEscapeReg.hasMatch(r'\6a\61\76'), true);
      });

      test('DOES match full "javascript" encoded as \\XX sequences', () {
        // \6a\61\76\61\73\63\72\69\70\74 = "javascript"
        expect(
          HtmlSanitizeConfig.unicodeEscapeReg
              .hasMatch(r'\6a\61\76\61\73\63\72\69\70\74'),
          true,
        );
      });

      test('does NOT match PHP-style backslash namespace separators', () {
        // Regression: \Sabre\DAV\Exception had \DA matching the old single-pair regex.
        expect(
          HtmlSanitizeConfig.unicodeEscapeReg
              .hasMatch(r'\Sabre\DAV\Exception\Forbidden'),
          false,
        );
        expect(
          HtmlSanitizeConfig.unicodeEscapeReg
              .hasMatch(r'\App\DB\Exception\AuthFailed'),
          false,
        );
      });
    });
  });
}
