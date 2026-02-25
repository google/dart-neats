import 'package:html/dom.dart';
import 'package:sanitize_html/src/attribute_policy.dart';
import 'package:test/test.dart';

void main() {
  group('AttributePolicy', () {
    test('id accepted only when safe', () {
      final elem = Element.tag('div');

      elem.attributes['id'] = 'validId123';
      expect(
        AttributePolicy.sanitizeAttribute(elem, 'id', 'validId123'),
        true,
      );

      elem.attributes['id'] = '-invalid!';
      expect(
        AttributePolicy.sanitizeAttribute(elem, 'id', '-invalid!'),
        false,
      );
    });

    test('class filters invalid class names', () {
      final elem = Element.tag('span')
        ..classes.addAll(['ok', '9invalid', '_alsoBad']);

      final result =
          AttributePolicy.sanitizeAttribute(elem, 'class', elem.className);

      expect(result, true);
      expect(elem.classes, ['ok']);
    });

    test('style sanitized correctly', () {
      final elem = Element.tag('div');
      elem.attributes['style'] = 'color: red; position: absolute;';

      final result = AttributePolicy.sanitizeAttribute(
          elem, 'style', elem.attributes['style']!);

      expect(result, true);
      expect(elem.attributes['style'], 'color: red');
    });

    test('A[href] validated correctly', () {
      final a = Element.tag('a');
      a.attributes['href'] = 'javascript:alert(1)';

      final ok =
          AttributePolicy.sanitizeAttribute(a, 'href', 'javascript:alert(1)');
      expect(ok, false);
    });
  });
}
