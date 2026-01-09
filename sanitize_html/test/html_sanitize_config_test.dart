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
  });
}
