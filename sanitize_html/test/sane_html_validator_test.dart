import 'package:sanitize_html/src/sane_html_validator.dart';
import 'package:test/test.dart';

void main() {
  group('SaneHtmlValidator.sanitize', () {
    group('Base behavior', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      group('Forbidden tags', () {
        test('removes script / iframe / object / embed / applet', () {
          final out = validator.sanitize('''
          <div>
            <script>alert(1)</script>
            <iframe src="x"></iframe>
            <object></object>
            <embed src="x"/>
            <applet></applet>
            <p>Valid</p>
          </div>
        ''');

          expect(out.contains('<script'), false);
          expect(out.contains('<iframe'), false);
          expect(out.contains('<object'), false);
          expect(out.contains('<embed'), false);
          expect(out.contains('<applet'), false);
          expect(out.contains('Valid'), true);
        });

        test('sanitize nested forbidden tags', () {
          final out = validator.sanitize('''
        <div>
          <script>
            <iframe>
              <object><embed></embed></object>
            </iframe>
          </script>
          <p>Visible</p>
        </div>
        ''');

          expect(out.contains('<script'), false);
          expect(out.contains('<iframe'), false);
          expect(out.contains('<object'), false);
          expect(out.contains('<embed'), false);
          expect(out.contains('Visible'), true);
        });

        test('unwrap unknown tag in full pipeline', () {
          expect(
            validator.sanitize('<xxx><p>Hello</p></xxx>').trim(),
            '<p>Hello</p>',
          );
        });
      });

      group('Forbidden form/interactive tags', () {
        test('removes interactive tags: input/button/select/textarea', () {
          final out = validator.sanitize('''
          <div>
            <input type="text"/>
            <button>Click</button>
            <textarea>abc</textarea>
            <select><option>A</option></select>
            <p>Hello</p>
          </div>
        ''');

          expect(out.contains('<input'), false);
          expect(out.contains('<button'), false);
          expect(out.contains('<textarea'), false);
          expect(out.contains('<select'), false);
          expect(out.contains('Hello'), true);
        });
      });

      group('Forbidden attributes', () {
        test('removes onclick/onload/onmouseover/etc', () {
          final out = validator.sanitize('''
          <div onclick="hack()" onmouseover="x">
            <img src="cid:abc" onload="evil()">
            <a href="http://a.com" onfocus="bad()"></a>
          </div>
        ''');

          expect(out.contains('onclick'), false);
          expect(out.contains('onmouseover'), false);
          expect(out.contains('onload'), false);
          expect(out.contains('onfocus'), false);
        });

        test('removes forbidden attributes nested deeply', () {
          final out = validator.sanitize('''
          <div>
            <span>
              <b onclick="1">
                <i onmousedown="2">
                  <a href="http://example.com" onkeypress="3">A</a>
                </i>
              </b>
            </span>
          </div>
        ''');

          expect(out.contains('onclick='), false);
          expect(out.contains('onmousedown='), false);
          expect(out.contains('onkeypress='), false);
          expect(out.contains('<a href="http://example.com"'), true);
        });
      });

      group('Style sanitization', () {
        test('sanitize STYLE inline attributes', () {
          final out = validator.sanitize(
            '<p style="color:red; position:absolute; background:url(javascript:evil)">X</p>',
          );

          expect(out.contains('color: red'), true);
          expect(out.contains('position'), false);
          expect(out.contains('javascript'), false);
        });

        test('sanitize STYLE tag as stylesheet', () {
          final out = validator.sanitize('''
          <style>
            p { color: red; position: absolute; }
            @media screen { p { display:block; } }
          </style>
          <p>Hi</p>
        ''');

          expect(out.contains('<p>Hi</p>'), true);
          expect(out.contains('position'), false);
          expect(out.contains('@media'), false);
        });
      });

      group('URL sanitization', () {
        test('sanitize A[href] with addLinkRel', () {
          final out =
              validator.sanitize('<a href="http://example.com">Link</a>');
          expect(out.contains('rel="nofollow"'), true);
        });

        test('javascript: URL removed entirely', () {
          final out =
              validator.sanitize('<a href="javascript:alert(1)">Bad</a>');
          expect(out.contains('href='), false);
        });

        test('cid: URLs are preserved', () {
          final out = validator.sanitize('<img src="cid:12345">');
          expect(out.contains('cid:12345'), true);
        });

        test(
            'valid base64 PNG data URL formated exactly (newline and tab removed)',
            () {
          const html = '<img src="data:image/png;base64,AAA\n\tBBB">';
          final out = validator.sanitize(html);

          expect(
            out,
            '<img src="data:image/png;base64,AAABBB">',
            reason:
                'Base64 data URL must be preserved as-is (Roundcube compatibility)',
          );
        });

        test('base64 image containing javascript: removed', () {
          final out = validator.sanitize(
            '<img src="data:image/png;base64,javascript:evil">',
          );
          expect(out.contains('src='), false);
        });

        test('invalid base64 images removed (non-base64 characters)', () {
          final out = validator.sanitize(
            '<img src="data:image/png;base64,INVALID@!"/>',
          );
          expect(out, contains('<img>'));
          expect(out, isNot(contains('src="data:image/png;base64,INVALID@!')));
        });

        test('SVG data URLs in img src are currently dropped', () {
          final out = validator.sanitize(
            '<img src="data:image/svg+xml;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg=="/>',
          );

          // <img> remains, but src is dropped
          expect(out, contains('<img>'));
          expect(out, isNot(contains('data:image/svg+xml')));
        });

        test('invalid image URLs removed (javascript inside src)', () {
          final out = validator.sanitize('<img src="javascript:evil()"/>');
          expect(out.contains('<img>'), true);
        });

        test('normalize whitespace inside non-data URLs', () {
          const html = '<a href=" http://example.com \n\t ">Link</a>';
          final out = validator.sanitize(html);

          expect(out.contains('href="http://example.com"'), true);
        });

        test('remove dangerous unicode-escaped javascript URLs', () {
          const html =
              '<a href="\\6A\\61\\76\\61\\73\\63\\72\\69\\70\\74:alert(1)">X</a>';
          final out = validator.sanitize(html);

          expect(out.contains('href='), false);
          expect(out.contains('alert'), false);
        });

        test('srcset sanitized properly (dropping javascript URLs)', () {
          const html = '''
      <img srcset="
          javascript:alert(1) 2x,
          http://safe.com/image.png 2x
      ">
    ''';

          final out = validator.sanitize(html);

          // javascript entry MUST be removed
          expect(out.contains('javascript:'), false);

          // safe entry SHOULD remain
          expect(out.contains('http://safe.com/image.png'), true);
        });
      });

      group('Real-world HTML structures', () {
        test('complex HTML sanitized safely', () {
          final out = validator.sanitize('''
          <div onclick="x">
            <blockquote>
              <style>p { color:red; position:absolute; }</style>
              <p onfocus="evil()" style="font-size:14px; background:url(js)">Hello</p>
              <img src="javascript:evil()"/>
              <iframe src="hack"></iframe>
              <custom-tag>
                <b onmouseover="x">World</b>
              </custom-tag>
            </blockquote>
          </div>
        ''');

          expect(out.contains('<iframe'), false);
          expect(out.contains('onclick'), false);
          expect(out.contains('onfocus'), false);
          expect(out.contains('onmouseover'), false);
          expect(out.contains('position'), false);
          expect(out.contains('url(js)'), false);
          expect(out.contains('font-size'), true);
          expect(out.contains('<img>'), true);
          expect(out.contains('<custom-tag>'), false);
          expect(out.contains('World'), true);
          expect(out.contains('Hello'), true);
        });
      });
    });

    group('Validator configuration – allowAttributes / allowTags', () {
      test('allowTags makes unknown tag allowed', () {
        final v = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: null,
          allowAttributes: null,
          allowTags: ['custom'],
        );

        expect(v.sanitize('<custom>Hello</custom>'), '<custom>Hello</custom>');
      });

      test('allowAttributes cannot override forbidden attributes', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: ['onclick'],
            allowTags: null,
          ),
          throwsArgumentError,
        );
      });

      test('allowAttributes allows safe attributes', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: ['data-foo', 'title'],
            allowTags: null,
          ),
          returnsNormally,
        );
      });

      test('allowAttributes throws when containing forbidden attribute', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: ['data-foo', 'onclick'],
            allowTags: null,
          ),
          throwsArgumentError,
        );
      });

      test('allowAttributes = null does not throw', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: null,
            allowTags: null,
          ),
          returnsNormally,
        );
      });

      test('allowTags cannot include forbidden tags', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: null,
            allowTags: ['script'],
          ),
          throwsArgumentError,
        );
      });

      test('allowTags throws if any forbidden tag is included', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: null,
            allowTags: ['custom', 'iframe'],
          ),
          throwsArgumentError,
        );
      });

      test('allowTags = null does not throw', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: null,
            allowTags: null,
          ),
          returnsNormally,
        );
      });

      test('keeping safe custom attributes', () {
        final v = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: null,
          allowAttributes: ['data-safe'],
          allowTags: null,
        );

        final out = v.sanitize('<p data-safe="1">Hi</p>');
        expect(out.contains('data-safe="1"'), true);
      });

      test('error message contains forbidden attribute name', () {
        try {
          SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: ['onclick'],
            allowTags: null,
          );
          fail('Expected an ArgumentError');
        } catch (e) {
          expect(e.toString(), contains('onclick'));
        }
      });

      test('constructor throws before sanitize() is called', () {
        expect(
          () => SaneHtmlValidator(
            allowElementId: (_) => true,
            allowClassName: (_) => true,
            addLinkRel: null,
            allowAttributes: ['onload'],
            allowTags: null,
          ),
          throwsArgumentError,
        );
      });
    });

    group('ID / ClassName validation', () {
      test('id validated by allowElementId', () {
        final v = SaneHtmlValidator(
          allowElementId: (id) => id == 'good',
          allowClassName: (_) => true,
          addLinkRel: null,
          allowAttributes: null,
          allowTags: null,
        );

        final out1 = v.sanitize('<p id="good">Hi</p>');
        final out2 = v.sanitize('<p id="bad">Hi</p>');

        expect(out1.contains('id='), true);
        expect(out2.contains('id='), false);
      });

      test('class validated by allowClassName', () {
        final v = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (c) => c.startsWith('x-'),
          addLinkRel: null,
          allowAttributes: null,
          allowTags: null,
        );

        final out = v.sanitize('<p class="x-one two x-two three">Hi</p>');

        expect(out.contains('x-one'), true);
        expect(out.contains('x-two'), true);
        expect(out.contains(' two '), false);
        expect(out.contains(' three'), false);
      });
    });

    group('Forbidden tag override attempts', () {
      test('each forbidden tag cannot be allowed', () {
        const forbidden = [
          'input',
          'textarea',
          'select',
          'option',
          'script',
          'iframe',
          'embed',
          'object',
          'applet',
        ];

        for (final tag in forbidden) {
          expect(
            () => SaneHtmlValidator(
              allowElementId: (_) => true,
              allowClassName: (_) => true,
              addLinkRel: null,
              allowAttributes: null,
              allowTags: [tag],
            ),
            throwsArgumentError,
            reason: 'Tag <$tag> must not be override-allowable',
          );
        }
      });

      test('forbidden form attributes cannot be allowed', () {
        const forbiddenAttrs = [
          'action',
          'method',
          'formaction',
          'formmethod',
          'enctype',
          'formtarget',
          'accept-charset',
          'autocomplete',
          'novalidate',
        ];

        for (final attr in forbiddenAttrs) {
          expect(
            () => SaneHtmlValidator(
              allowElementId: (_) => true,
              allowClassName: (_) => true,
              addLinkRel: null,
              allowAttributes: [attr],
              allowTags: null,
            ),
            throwsArgumentError,
            reason: 'Attribute $attr must not be override-allowable',
          );
        }
      });
    });

    group('Sanitize form tags & nested form structure', () {
      final validator = SaneHtmlValidator(
        allowElementId: (_) => true,
        allowClassName: (_) => true,
        addLinkRel: null,
        allowAttributes: null,
        allowTags: null,
      );

      test('removes <form>', () {
        expect(
          validator.sanitize('<form action="/x"><p>Hi</p></form>'),
          '<p>Hi</p>',
        );
      });

      test('removes <form> with interactive children', () {
        final out = validator.sanitize('''
        <form>
          <input type="text" value="abc">
          <button>Click</button>
          <p>Ok</p>
        </form>
      ''');

        expect(out.contains('<input'), false);
        expect(out.contains('<button'), false);
        expect(out.contains('<form'), false);
        expect(out.contains('<p>Ok</p>'), true);
      });

      test('removes nested form inside other tags', () {
        final out = validator.sanitize('''
        <div>
          <form><textarea>abc</textarea></form>
        </div>
      ''');

        expect(out.contains('<form'), false);
        expect(out.contains('<textarea'), false);
      });

      test('removes input/textarea/select/option', () {
        final out = validator.sanitize('''
        <div>
          <input />
          <textarea>Hello</textarea>
          <select><option>A</option></select>
          <p>Hi</p>
        </div>
      ''');

        expect(out.contains('<input'), false);
        expect(out.contains('<textarea'), false);
        expect(out.contains('<select'), false);
        expect(out.contains('<option'), false);
        expect(out.contains('<p>Hi</p>'), true);
      });

      test('removes forbidden tags but keeps valid descendants', () {
        final out = validator.sanitize('''
        <form>
          <div>
            <span>Hello</span>
          </div>
        </form>
      ''');

        expect(out.contains('<form'), false);
        expect(out.contains('<span>Hello</span>'), true);
      });

      test('does not unwrap forbidden tags — always remove them', () {
        final out = validator.sanitize('<form><span>Hi</span></form>');
        expect(out, '<span>Hi</span>');
      });
    });

    group('Deeply nested complex HTML', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test(
          'heavily nested forbidden tags with dangerous attributes removed correctly',
          () {
        const html = '''
      <div onclick="rootBad()">
        <section>
          <xxx>
            <yyy>
              <zzz>
                <form action="/hack" method="post">
                  <script>
                    alert("attack");
                    <iframe src="js:evil"></iframe>
                  </script>
                  <p style="color:red; position:absolute">Text</p>
                  <custom1>
                    <custom2>
                      <b onmouseover="evil()">Bold</b>
                      <img src="javascript:steal()"/>
                      <i>
                        <object>
                          <embed src="hacked"/>
                        </object>
                      </i>
                      <a href="javascript:alert(1)" onclick="bad()">Click</a>
                    </custom2>
                  </custom1>
                </form>
              </zzz>
            </yyy>
          </xxx>
        </section>
        <footer>
          <blockquote>
            <style>
              .x { position:absolute; background:url(js); }
            </style>
          </blockquote>
        </footer>
      </div>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<form'), false);
        expect(out.contains('<script'), false);
        expect(out.contains('<iframe'), false);
        expect(out.contains('<object'), false);
        expect(out.contains('<embed'), false);
        expect(out.contains('onclick='), false);
        expect(out.contains('onmouseover='), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('position'), false);
        expect(out.contains('background:url(js)'), false);
        expect(out.contains('rootBad()'), false);
        expect(out.contains('<custom1'), false);
        expect(out.contains('<custom2'), false);
        expect(out.contains('Bold'), true);
        expect(out.contains('Text'), true);
        expect(out.contains('<img>'), true);
        expect(out.contains('<a'), true);
        expect(out.contains('href='), false);
        expect(out.contains('absolute'), false);
        expect(out.contains('alert'), false);
      });

      test('extreme depth nesting with unknown tags is correctly unwrapped',
          () {
        const html = '''
      <layer1>
        <layer2>
          <layer3>
            <layer4>
              <layer5>
                <layer6>
                  <layer7>
                    <layer8>
                      <div>
                        <script>alert(1)</script>
                        <p>Hello World</p>
                      </div>
                    </layer8>
                  </layer7>
                </layer6>
              </layer5>
            </layer4>
          </layer3>
        </layer2>
      </layer1>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<p>Hello World</p>'), true);
        expect(out.contains('<script'), false);
      });

      test('complex mixed inline attributes, CSS, scripts, and nested images',
          () {
        const html = '''
      <div style="position:absolute">
        <span onclick="bad()">
          <p style="background:url(javascript:evil)">A</p>
          <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA"/>
          <img src="data:image/png;base64,INVALID###"/>
          <img src="javascript:fake()"/>
          <script>console.log("XSS")</script>
        </span>
      </div>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('position'), false);
        expect(out.contains('javascript:evil'), false);
        expect(out.contains('onclick='), false);
        expect(out.contains('<script'), false);
        expect(
          out.contains('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA'),
          true,
        );
        expect(out.contains('<img>'), true);
        expect(out.contains('javascript:'), false);
        expect(out.contains('A'), true);
      });

      test(
          'multiple nested custom tags with unsafe children removed, safe text remains',
          () {
        const html = '''
      <aaa>
        <bbb>
          <ccc>
            <ddd onclick="1">
              <eee>
                <fff>
                  <g1><g2><g3><g4><script>x</script></g4></g3></g2></g1>
                  <u>Hello</u>
                  <iframe src="evil"></iframe>
                </fff>
              </eee>
            </ddd>
          </ccc>
        </bbb>
      </aaa>
    ''';

        final out = validator.sanitize(html);

        // All wrappers removed
        expect(out.contains('<aaa'), false);
        expect(out.contains('<bbb'), false);
        expect(out.contains('<ccc'), false);
        expect(out.contains('<ddd'), false);
        expect(out.contains('<eee'), false);
        expect(out.contains('<fff'), false);

        // Forbidden removed
        expect(out.contains('<script'), false);
        expect(out.contains('<iframe'), false);

        // Safe inline tags remain
        expect(out.contains('<u>Hello</u>'), true);
      });
    });

    group('Advanced XSS vectors (SVG, MathML, XMLNS, encoded)', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('strip SVG with script, animate, foreignObject, and unsafe href',
          () {
        const html = '''
      <svg>
        <script>alert(1)</script>
        <animate attributeName="href" from="javascript:evil()" to="x"/>
        <foreignObject><div>Test</div></foreignObject>
        <a href="javascript:alert(2)">Click</a>
      </svg>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<svg'), true);
        expect(out.contains('foreignObject'), false);
        expect(out.contains('<script'), false);
        expect(out.contains('animate'), false);
        expect(out.contains('javascript:'), false);
      });

      test('MathML tags removed: <math> <mstyle> <mscript>', () {
        const html = '''
      <math>
        <mstyle>
          <mscript>
            <mprescripts>
              <script>alert("x")</script>
            </mprescripts>
            Content
          </mscript>
        </mstyle>
      </math>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<math'), false);
        expect(out.contains('<mstyle'), false);
        expect(out.contains('<mscript'), false);
        expect(out.contains('script'), false);
      });

      test('strip XMLNS-based attributes that enable JS', () {
        const html = '''
      <svg xmlns="http://www.w3.org/2000/svg"
           xmlns:xlink="http://www.w3.org/1999/xlink">
        <a xlink:href="javascript:alert(1)">Bad</a>
      </svg>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('xmlns'), false);
        expect(out.contains('xlink:'), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('Bad'), true);
      });

      test('meta refresh removed entirely', () {
        const html = '''
      <meta http-equiv="refresh" content="0;url=javascript:alert(1)">
      <p>Hello</p>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<meta'), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('<p>Hello</p>'), true);
      });

      test('remove <link> tags (stylesheet or preload)', () {
        const html = '''
      <link rel="stylesheet" href="http://evil.com/x.css">
      <link rel="preload" href="javascript:evil()">
      <p>Hi</p>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('<link'), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('<p>Hi</p>'), true);
      });

      test('percent-encoded (alert(1)) javascript URL removed', () {
        const html = '''
      <a href="javascript:%61%6C%65%72%74%281%29">Click</a>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('href='), false);
        expect(out.contains('javascript'), false);
      });

      test('percent-encoded (javascript) javascript URL removed', () {
        const html = '''
      <a href="%6a%61%76%61%73%63%72%69%70%74:alert(1)">Click</a>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('href='), false);
        expect(out.contains('alert'), false);
      });

      test('unicode-escaped javascript URL removed', () {
        const html = '''
      <a href="\\6A\\61\\76\\61\\73\\63\\72\\69\\70\\74:alert(1)">Click</a>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('href='), false);
        expect(out.contains('alert'), false);
      });

      test('base64-encoded javascript URL removed', () {
        const html = '''
      <a href="data:text/html;base64,amF2YXNjcmlwdDphbGVydCgxKQ==">
        Bad
      </a>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('href='), false);
        expect(out.contains('amF2YX'), false);
      });

      test('data-* attributes containing JS should not leak events', () {
        const html = '''
      <div data-x="onload=evil()" data-y="javascript:alert(1)">
        Hi
      </div>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('onload'), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('data-x'), false);
        expect(out.contains('data-y'), false);
        expect(out.contains('Hi'), true);
      });

      test('bidi control characters inside href do not allow javascript URL',
          () {
        const html = '<a href="jav\u202Escript:alert(1)">Click</a>';

        final out = validator.sanitize(html);

        expect(out.contains('href='), false);
        expect(out.contains('alert'), false);
        expect(out.contains('Click'), true);
      });

      test('srcset javascript URL removed', () {
        const html = '<img srcset="javascript:alert(1) 1x">';

        final out = validator.sanitize(html);

        expect(out.contains('srcset='), false);
        expect(out.contains('javascript:'), false);
      });

      test('HTML comment injection cannot break attribute parsing', () {
        const html = '<img src="--><script>alert(1)</script>">';
        final out = validator.sanitize(html);

        expect(out.contains('<script'), false);
        expect(out.contains('alert'), false);
      });
    });

    group('Complex real-world email payloads', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('mixed complex snippet with many vectors sanitized safely', () {
        const html = '''
          <div onclick="rootBad()">
            <!-- hidden script -->
            <!-- <script>alert(1)</script> -->
            <blockquote>
              <style>
                p { color:red; position:absolute; background:url(javascript:evil); }
              </style>
              <p onfocus="evil()"
                 style="font-size:14px; background:url(js)">
                Hello
              </p>
              <img src="javascript:evil()"/>
              <iframe src="hack"></iframe>
              <custom-tag>
                <b onmouseover="x">World</b>
              </custom-tag>
              <a href="javascript:alert(1)">link</a>
            </blockquote>
          </div>
        ''';

        final out = validator.sanitize(html);

        expect(out.contains('onclick='), false);
        expect(out.contains('<script'), false);
        expect(out.contains('position'), false);
        expect(out.contains('background:url'), false);
        expect(out.contains('onfocus='), false);
        expect(out.contains('onmouseover='), false);
        expect(out.contains('<iframe'), false);
        expect(out.contains('javascript:'), false);
        expect(out.contains('<custom-tag'), false);
        expect(out.contains('Hello'), true);
        expect(out.contains('World'), true);
      });
    });

    group('HTML safety and XSS hardening tests', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('XSS – strip data:, vbscript:, data:application links', () {
        const html = ''
            '<a href="data:text/html,&lt;script&gt;alert(document.cookie)&lt;/script&gt;">Firefox</a>'
            '<a href="vbscript:alert(document.cookie)">Internet Explorer</a>'
            '<A href="data:text/html,&lt;script&gt;alert(document.cookie)&lt;/script&gt;">Firefox</a>'
            '<A HREF="vbscript:alert(document.cookie)">Internet Explorer</a>'
            '<a href="data:application/xhtml+xml;base64,PGh0bW">CLICK ME</a>';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('data:text')),
            reason: 'data:text/html removed');
        expect(out, isNot(contains('vbscript:')), reason: 'vbscript removed');
        expect(out, isNot(contains('data:application')),
            reason: 'data:application removed');
      });

      test('href – normalize newlines in href attribute', () {
        const html =
            '<p><a href="\nhttp://test.com\n">Firefox</a><a href="domain.com">Firefox</a>';

        final out = validator.sanitize(html);

        expect(out, contains('href="http://test.com"'));
      });

      test('AREA – remove data:, vbscript:, javascript: in href', () {
        const html = ''
            '<p><area href="data:text/html,&lt;script&gt;alert(document.cookie)&lt;/script&gt;">'
            '<area href="vbscript:alert(document.cookie)">IE</p>'
            '<area href="javascript:alert(document.domain)" shape=default>'
            '<p><AREA HREF="data:text/html,&lt;script&gt;alert(document.cookie)&lt;/script&gt;">'
            '<Area href="vbscript:alert(document.cookie)">IE</p>'
            '<area HREF="javascript:alert(document.domain)" shape=default>';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('data:text')));
        expect(out, isNot(contains('vbscript:')));
        expect(out, isNot(contains('javascript:')));
      });

      test('object – remove <object>/<param> but preserve children', () {
        const html = '''
<div>
  <object data="move.swf" type="application/x-shockwave-flash">
    <param name="foo" value="bar">
    <p>This alternative text should survive</p>
  </object>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('<object')));
        expect(out, isNot(contains('<param')));
        expect(out, contains('This alternative text should survive'));
      });

      test('comments – remove all comments safely', () {
        washer(String html) => validator.sanitize(html);

        expect(
          washer('<!--[if gte mso 10]><p>p1</p><!--><p>p2</p>'),
          '<p>p2</p>',
        );
        expect(washer('<!--TestCommentInvalid><p>test</p>'), '<p>test</p>');
        expect(
          washer('<p>para1</p><!-- comment --><p>para2</p>'),
          '<p>para1</p><p>para2</p>',
        );
        expect(
          washer('<p>para1</p><!-- <hr> comment --><p>para2</p>'),
          '<p>para1</p><p>para2</p>',
        );
        expect(
          washer('<p>para1</p><!-- comment => comment --><p>para2</p>'),
          '<p>para1</p><p>para2</p>',
        );
        expect(
          washer(
              '<p><!-- span>1</span -->\n<span>2</span>\n<!-- >3</span --><span>4</span></p>'),
          '<p>\n<span>2</span>\n<span>4</span></p>',
        );
      });

      test('textarea – forbidden, remove tag and its content', () {
        const html = '<textarea>test';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('<textarea')));
        expect(out, isNot(contains('test')));
      });

      test('closing tag with attributes – invalid closing attributes stripped',
          () {
        const html = '<a href="http://test.com">test</a href>';

        final out = validator.sanitize(html);

        expect(out, contains('</a>'));
      });

      test('style – preserve font-size and rgb() colors', () {
        const html =
            '<p style="font-size: 10px; color: rgb(241, 245, 218)">a</p>';

        final out = validator.sanitize(html);

        expect(out, contains('color: rgb(241, 245, 218)'));
        expect(out, contains('font-size: 10px'));
      });

      test('style – preserve line-height, normalize height unit & whitespace',
          () {
        const html1 = '<p style="line-height: 1; height: 10">a</p>';
        final out1 = validator.sanitize(html1);

        expect(out1, contains('line-height: 1;'));
        expect(out1, contains('height: 10px'));

        const html2 =
            '<div style="padding: 0px\n   20px;border:1px solid #000;"></div>';
        final out2 = validator.sanitize(html2);

        expect(out2, contains('padding: 0px 20px;'));
        expect(out2, contains('border: 1px solid #000'));
      });

      test('style – disallow onerror injection via quote manipulation', () {
        final out1 =
            validator.sanitize("<img style=aaa:'\"/onerror=alert(1)//'>");
        expect(out1, isNot(contains('onerror=alert(1)')));

        final out2 =
            validator.sanitize("<img style=aaa:'&quot;/onerror=alert(1)//'>");
        expect(out2, isNot(contains('onerror=alert(1)')));
      });

      test('title – drop <title> content from output', () {
        final out1 = validator.sanitize(
            '<html><head><title>title1</title></head><body><p>test</p></body>');
        expect(out1, '<p>test</p>');

        final out2 = validator.sanitize(
            '<html><head><title>title1<img />title2</title></head><body><p>test</p></body>');
        expect(out2, '<p>test</p>');
      });

      test('SVG – sanitize complex SVG elements safely', () {
        const svg = '''
<svg version="1.1" xmlns="http://www.w3.org/2000/svg">
  <polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke="#004400" onmouseover="alert(1)" />
  <text x="50" y="68" font-size="48" fill="#FFF">410</text>
  <script>alert(document.cookie);</script>
  <foreignObject xlink:href="data:text/xml,%3Cscript%3Ealert(1)%3C/script%3E"/>
  <set attributeName="onmouseover" to="alert(1)"/>
  <animate attributeName="onunload" to="alert(1)"/>
</svg>
''';

        final out = validator.sanitize(svg);

        expect(out, contains('<polygon'));
        expect(out, isNot(contains('onmouseover="alert(1)"')));
        expect(out, isNot(contains('<script')));
        expect(out, isNot(contains('foreignObject')));
        expect(out, isNot(contains('<set ')));
        expect(out, isNot(contains('<animate ')));
        expect(out, contains('410'));
      });

      test('SVG – wash javascript: in xlink:href', () {
        const html =
            '<svg><a xlink:href="javascript:alert(1)"><text>XSS</text></a></svg>';

        final out = validator.sanitize(html);

        expect(out, contains('<svg>'));
        expect(out, isNot(contains('javascript:alert(1)')));
        expect(out, contains('XSS'));
      });

      test('SVG – remove animate/set with JS payload', () {
        const animateHtml = '<svg>'
            '<animate attributeName="href" values="javascript:alert(1)" />'
            '<a id="xss"><text>XSS</text></a>'
            '</svg>';

        final out1 = validator.sanitize(animateHtml);
        expect(out1, isNot(contains('<animate')));
        expect(out1, contains('<a id="xss">'));
        expect(out1, contains('XSS'));

        const setHtml = '<svg>'
            '<set attributeName="href" to="javascript:alert(1)" />'
            '<a id="xss"><text>XSS</text></a>'
            '</svg>';

        final out2 = validator.sanitize(setHtml);
        expect(out2, isNot(contains('<set')));
        expect(out2, contains('<a id="xss">'));
      });

      test('XSS – remove javascript: in href/src attributes', () {
        const html = '<html><body>'
            '<a href="javascript:alert(1)">X</a>'
            '<img src="javascript:alert(1)" />'
            '</body></html>';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('href="javascript:')));
        expect(out, isNot(contains('src="javascript:')));
        expect(out, contains('X'));
      });

      test('body background – remove javascript: in background attr', () {
        const html =
            '<html><body background="javascript:alert(1)">test</body></html>';
        final out = validator.sanitize(html);

        expect(out, isNot(contains('background="javascript:')));
        expect(out, contains('test'));
      });

      test('textarea – forbidden, remove tag, content and XSS attributes', () {
        const html =
            '<textarea><p style="x:</textarea><img src=x onerror=alert(1)>">';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('textarea')));
        expect(out, isNot(contains('<p style="x:')));
        expect(out, isNot(contains('onerror=')));
        expect(out, contains('<img src="x">'));
      });

      test('CDATA – script inside CDATA removed', () {
        const html =
            '<p><![CDATA[<script>alert(document.cookie)</script>]]></p>';

        final out = validator.sanitize(html);

        expect(out, isNot(contains('<script>')));
        expect(out, isNot(contains('alert(document.cookie)')));
      });

      test('XML – remove XML tag, namespace, prolog', () {
        const html1 = '<p><?xml:namespace prefix="xsl" /></p>';
        final out1 = validator.sanitize(html1);
        expect(out1, '<p></p>');

        const html2 = '<?xml encoding="UTF-8"><html><body>HTML</body></html>';
        final out2 = validator.sanitize(html2);
        expect(out2, 'HTML');
      });

      test('missing html/body tags – body content still preserved', () {
        washer(String html) => validator.sanitize(html);

        expect(
          washer('<head></head>First line<br />Second line'),
          contains('First line'),
        );
        expect(washer('First line<br />Second line'), contains('First line'));
        expect(washer('<html>First line</html>'), contains('First line'));
        expect(washer('<html><body>First</body></html>'), contains('First'));
      });

      test('table nested – normalize malformed nested <tr>', () {
        const html = '''
<table id="t1">
  <tr>
    <td>
      <table id="t2">
        <tr>
        <tr>
          <td></td>
        </tr>
        </tr>
      </table>
    </td>
  </tr>
  <tr><td></td></tr>
</table>
''';

        final out = validator.sanitize(html);
        final canonical = out.replaceAll(RegExp(r'>[^<>]+<'), '><');

        expect(canonical, contains('<table id="t1"'));
        expect(canonical, contains('<table id="t2"'));
        expect(
          RegExp(r'<tr>').allMatches(canonical).length,
          greaterThanOrEqualTo(2),
        );
      });
    });

    group('Sanitize – Keep harmless JS-like text content', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('Keep alert(), window.alert and JS examples in text', () {
        const html = '''
<div>
  <h2>Emergency Instructions</h2>
  <p>Please call the alert() function immediately when the system detects an error!</p>
  <p>This is important: use the alert() method to notify users.</p>
  <p>Example code: <code>window.alert('System error detected')</code></p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('alert()'));
        expect(out, contains('window.alert'));
        expect(out, contains('Please call the alert() function'));
      });

      test('Keep arrow functions and => in text', () {
        const html = '''
<div>
  <h2>JavaScript Tutorial: Arrow Functions</h2>
  <p>Arrow functions use the syntax: <code>(a, b) => a + b</code></p>
  <p>Click the arrow => to continue</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('Arrow functions use the syntax:'));
        expect(out, contains('(a, b)'));
        expect(out, contains('Click the arrow'));
      });

      test(
          'Keep JS functions, DOM access, addEventListener, even alert() in code samples',
          () {
        const html = '''
<div>
  <h1>JavaScript Best Practices</h1>
  <code>
  function greet(name) {
    alert('Hello ' + name);
  }
  </code>
  <p>Use window.addEventListener for events</p>
  <p>document.querySelector('.my-class')</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('alert('));
        expect(out, contains('window.addEventListener'));
        expect(out, contains('document.querySelector'));
      });

      test('Keep document.pdf, document.docx, document.getElementById', () {
        const html = '''
<div>
  <p>Please check the document.pdf file</p>
  <p>The document.getElementById method is useful</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('document.pdf'));
        expect(out, contains('document.getElementById'));
      });

      test('Keep "eval(uation)" and eval() text examples', () {
        const html = '''
<div>
  <p>Never use the eval() function in production</p>
  <p>Please evaluate(assessment)</p>
  <p>Contact the eval(uation) team.</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('eval('));
        expect(out, contains('evaluate'));
        expect(out, contains('eval(uation)'));
      });

      test('Keep function() and code examples', () {
        const html = '''
<div>
  <p>You can define a function(param) like this:</p>
  <code>function add(a, b) { return a + b; }</code>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('function add'));
        expect(out, contains('function(param)'));
      });

      test('Keep all JS training examples', () {
        const html = '''
<div>
  <h3>Alerts</h3>
  <p>How to use alert() for user notifications</p>
  <p>The alert() dialog is synchronous</p>

  <h3>DOM</h3>
  <p>document.getElementById</p>

  <h3>Window</h3>
  <p>window.location.href</p>

  <h3>Functions</h3>
  <p>(x, y) => x + y</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('alert()'));
        expect(out, contains('document.getElementById'));
        expect(out, contains('window.location'));
      });

      test('Original: Keep window.location / window.display etc.', () {
        const html = '''
<div>
  <p>Please visit the window.location in the main building</p>
  <p>The new window.display area is now open!</p>
  <p>window.addEventListener is useful</p>
  <p>window.glass weekly</p>
</div>
''';

        final out = validator.sanitize(html);

        expect(out, contains('window.location'));
        expect(out, contains('window.display'));
        expect(out, contains('window.addEventListener'));
        expect(out, contains('window.glass'));
      });
    });

    group('CSS Sanitization – Validator integration', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('keeps safe url() in background-image', () {
        final out = validator.sanitize(
          '<p style="background-image: url(/images/header.jpg); padding: 20px;">X</p>',
        );

        expect(out.contains('background-image: url(/images/header.jpg)'), true);
        expect(out.contains('padding: 20px'), true);
        expect(out.contains('X'), true);
      });

      test('keeps https url() in background-image', () {
        final out = validator.sanitize(
          '<p style="background-image: url(https://example.com/bg.png);"></p>',
        );

        expect(
          out.contains('background-image: url(https://example.com/bg.png)'),
          true,
        );
      });

      test('allows data:image/* base64 url() in background-image', () {
        final out = validator.sanitize(
          '<p style="background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA);">A</p>',
        );

        expect(
          out.contains(
            'background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA)',
          ),
          true,
        );
        expect(out.contains('A'), true);
      });

      test('removes javascript: url() but keeps safe properties', () {
        final out = validator.sanitize(
          '<p style="background-image: url(javascript:evil); color: red;">X</p>',
        );

        // background-image must be removed
        expect(out.contains('background-image'), false);

        // safe property kept
        expect(out.contains('color: red'), true);

        expect(out.contains('X'), true);
      });

      test('keeps opacity property', () {
        final out = validator.sanitize('<p style="opacity: 0.9">X</p>');

        expect(out.contains('opacity: 0.9'), true);
      });

      test('keeps box-shadow property', () {
        final out = validator.sanitize(
          '<p style="box-shadow: 0 2px 5px rgba(0,0,0,0.2);">X</p>',
        );

        expect(
          out.contains('box-shadow: 0 2px 5px rgba(0,0,0,0.2)'),
          true,
        );
      });

      test('keeps text-shadow property', () {
        final out = validator.sanitize(
          '<p style="text-shadow: 1px 1px 2px #333;">X</p>',
        );

        expect(out.contains('text-shadow: 1px 1px 2px #333'), true);
      });

      test('keeps display:flex', () {
        final out = validator.sanitize('<p style="display: flex;">X</p>');

        expect(out.contains('display: flex'), true);
      });

      test('keeps justify-content for flexbox', () {
        final out = validator.sanitize(
          '<p style="display: flex; justify-content: space-between;">X</p>',
        );

        expect(out.contains('display: flex'), true);
        expect(out.contains('justify-content: space-between'), true);
      });

      test('keeps align-items for flexbox', () {
        final out = validator.sanitize(
          '<p style="display: flex; align-items: center;">X</p>',
        );

        expect(out.contains('align-items: center'), true);
      });

      test('keeps flex shorthand', () {
        final out = validator.sanitize('<p style="flex: 1;">X</p>');

        expect(out.contains('flex: 1'), true);
      });

      test('keeps safe background-image', () {
        final out = validator.sanitize(
          '<p style="background-image: url(/img/bg.png);">X</p>',
        );

        expect(out.contains('background-image: url(/img/bg.png)'), true);
      });

      test('removes unsafe background-image with javascript url()', () {
        final out = validator.sanitize(
          '<p style="background-image: url(javascript:evil); opacity: 1;">X</p>',
        );

        // background-image must be removed
        expect(out.contains('background-image'), false);

        // opacity is safe and should remain
        expect(out.contains('opacity: 1'), true);

        expect(out.contains('X'), true);
      });

      test('drop style when no allowed properties remain', () {
        const html =
            '<p style="position:absolute; behavior:url(#default#time2); zoom:1">Hi</p>';

        final out = validator.sanitize(html);

        expect(out, contains('<p>Hi</p>'));

        expect(
          out,
          isNot(contains('style=')),
          reason:
              'When all CSS properties are forbidden, the style attribute should be removed.',
        );

        expect(out, isNot(contains('position')));
        expect(out, isNot(contains('behavior')));
        expect(out, isNot(contains('zoom')));
      });

      test('javascript URL inside url() is removed', () {
        const html =
            '<p style="background-image:url(javascript:alert(1)); color:red">Hi</p>';

        final out = validator.sanitize(html);

        expect(
          out,
          contains('color: red'),
          reason:
              'Safe CSS properties in the same style attribute must be preserved.',
        );

        expect(
          out,
          isNot(contains('background-image')),
          reason:
              'background-image using javascript: in url() must be dropped.',
        );
        expect(
          out,
          isNot(contains('url(')),
          reason:
              'Unsafe url() declarations must not leak into sanitized output.',
        );
        expect(
          out,
          isNot(contains('javascript:')),
          reason: 'javascript: schemes must be fully removed from inline CSS.',
        );

        expect(out, contains('Hi'));
      });

      test('SVG – strip animation attributes on allowed elements', () {
        const html = '<svg>'
            '<rect width="100" height="100" '
            'values="0;1" dur="5s" begin="0s" repeatCount="indefinite">'
            '</rect>'
            '</svg>';

        final out = validator.sanitize(html);

        // Animation attributes should be stripped
        expect(out, isNot(contains('values=')));
        expect(out, isNot(contains('dur=')));
        expect(out, isNot(contains('begin=')));
        expect(out, isNot(contains('repeatCount=')));

        // But the rect element should remain
        expect(out, contains('<rect'));
        expect(out, contains('width="100"'));
        expect(out, contains('height="100"'));
      });
    });

    group('Text nodes with JS-like content (non-executable)', () {
      late SaneHtmlValidator validator;

      setUp(() {
        validator = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => ['nofollow'],
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('KEEPS plain text containing document.cookie', () {
        const html = 'hello <p>document.cookie</p> world';
        expect(
          validator.sanitize(html),
          equals('hello <p>document.cookie</p> world'),
        );
      });

      test('KEEPS plain text containing document.location', () {
        const html = 'see <p>document.location</p> for details';
        expect(
          validator.sanitize(html),
          equals('see <p>document.location</p> for details'),
        );
      });

      test('KEEPS plain text containing window.location', () {
        const html = '<p>window.location.href</p>';
        expect(
          validator.sanitize(html),
          equals('<p>window.location.href</p>'),
        );
      });

      test('KEEPS plain text containing document.write reference', () {
        const html = '<p>Avoid using document.write in production</p>';
        expect(
          validator.sanitize(html),
          equals('<p>Avoid using document.write in production</p>'),
        );
      });

      test('KEEPS plain text that looks like JS function call', () {
        const html = '<p>alert("test")</p>';
        expect(
          validator.sanitize(html),
          equals('<p>alert("test")</p>'),
        );
      });

      test('KEEPS plain text with function keyword', () {
        const html = '<p>function test() { return 1; }</p>';
        expect(
          validator.sanitize(html),
          equals('<p>function test() { return 1; }</p>'),
        );
      });

      test('KEEPS JS keywords inside code tag', () {
        const html = '<code>document.cookie</code>';
        expect(
          validator.sanitize(html),
          equals('<code>document.cookie</code>'),
        );
      });

      test('KEEPS JS keywords inside preformatted text', () {
        const html = '<pre>if (document.cookie) { /* ... */ }</pre>';
        expect(
          validator.sanitize(html),
          equals('<pre>if (document.cookie) { /* ... */ }</pre>'),
        );
      });

      test('KEEPS plain text JS keywords inside SVG text node', () {
        const html = '''
<svg>
  <text>document.cookie</text>
</svg>
''';

        expect(
          validator.sanitize(html).contains('document.cookie'),
          true,
        );
      });

      // Control cases: executable contexts must still be removed

      test('REMOVES document.cookie inside script tag', () {
        const html = '<script>document.cookie</script>';
        expect(
          validator.sanitize(html),
          equals(''),
        );
      });

      test('REMOVES document.cookie inside onclick attribute', () {
        const html = '<button onclick="document.cookie">Click</button>';
        expect(
          validator.sanitize(html).contains('onclick'),
          false,
        );
      });
    });

    group('SaneHtmlValidator – internal CSS', () {
      late SaneHtmlValidator sanitizer;

      setUp(() {
        sanitizer = SaneHtmlValidator(
          allowElementId: (_) => true,
          allowClassName: (_) => true,
          addLinkRel: (_) => null,
          allowAttributes: null,
          allowTags: null,
        );
      });

      test('preserves internal <style> and body content', () {
        const html = '''
<html>
  <head>
    <style>
      .title { color: red; font-size: 14px; }
    </style>
  </head>
  <body>
    <div class="title">Hello</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        expect(result, contains('<style>'));
        expect(result, contains('.title'));
        expect(result, contains('color: red'));
        expect(result, contains('<div class="title">Hello</div>'));
      });

      test('preserves multiple <style> tags in order', () {
        const html = '''
<html>
  <head>
    <style>.a { color: red; }</style>
    <style>.b { color: blue; }</style>
  </head>
  <body>
    <div class="a b">Text</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        final firstIndex = result.indexOf('.a { color: red }');
        final secondIndex = result.indexOf('.b { color: blue }');

        expect(firstIndex, isNot(-1));
        expect(secondIndex, isNot(-1));
        expect(firstIndex < secondIndex, isTrue);
      });

      test('preserves <style media> attribute', () {
        const html = '''
<html>
  <head>
    <style media="screen and (max-width:600px)">
      .mobile { display: none; }
    </style>
  </head>
  <body>
    <div class="mobile">Hidden</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        expect(
          result,
          contains('<style media="screen and (max-width:600px)">'),
        );
        expect(result, contains('.mobile'));
      });

      test('removes dangerous CSS values', () {
        const html = '''
<html>
  <head>
    <style>
      .x { background-image: url(javascript:alert(1)); }
    </style>
  </head>
  <body>
    <div class="x">Test</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('<style>')));
        expect(result, isNot(contains('javascript:')));
      });

      test('<style> is not duplicated inside body', () {
        const html = '''
<html>
  <head>
    <style>.x { color: red; }</style>
  </head>
  <body>
    <p>Hello</p>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        final styleCount = RegExp('<style').allMatches(result).length;

        expect(styleCount, equals(1));
      });

      test('works when HTML has no <head>', () {
        const html = '''
<body>
  <style>.x { color: red; }</style>
  <div class="x">Hello</div>
</body>
''';

        final result = sanitizer.sanitize(html);

        expect(result, contains('<style>'));
        expect(result, contains('.x'));
        expect(result, contains('Hello'));
      });

      test('ignores empty <style>', () {
        const html = '''
<html>
  <head>
    <style>   </style>
  </head>
  <body>
    <div>Hello</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('<style>')));
      });

      test('CSS XSS: removes javascript: in url()', () {
        const html = '''
<html>
  <head>
    <style>
      .x {
        background-image: url(javascript:alert(1));
      }
    </style>
  </head>
  <body>
    <div class="x">Test</div>
  </body>
</html>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('<style>')));
        expect(result, isNot(contains('javascript:')));
        expect(result, contains('<div class="x">Test</div>'));
      });

      test('CSS XSS: removes obfuscated javascript url', () {
        const html = '''
<style>
  .x {
    background: url(  JaVaScRiPt:alert(1)  );
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('javascript')));
      });

      test('CSS XSS: removes expression()', () {
        const html = '''
<style>
  .x {
    width: expression(alert(1));
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('expression')));
      });

      test('CSS XSS: removes @import remote css', () {
        const html = '''
<style>
  @import url("https://evil.com/x.css");
  .x { color: red; }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('@import')));
        expect(result, contains('.x'));
      });

      test('CSS XSS: removes obfuscated @import', () {
        const html = '''
<style>
  @iMpOrT "https://evil.com/x.css";
</style>
<div>X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result.toLowerCase(), isNot(contains('@import')));
      });

      test('CSS XSS: removes behavior property', () {
        const html = '''
<style>
  .x {
    behavior: url(xss.htc);
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('behavior')));
      });

      test('CSS XSS: removes -moz-binding', () {
        const html = '''
<style>
  .x {
    -moz-binding: url("http://evil.com/xss.xml#xss");
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('-moz-binding')));
      });

      test('CSS XSS: blocks data:text/html', () {
        const html = '''
<style>
  .x {
    background-image: url(data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==);
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('data:text/html')));
      });

      test('CSS XSS: allows data:image/png when configured', () {
        const html = '''
<style>
  .x {
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA);
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, contains('data:image/png'));
      });

      test('CSS XSS: strips escaped javascript sequences', () {
        const html = r'''
<style>
  .x {
    background-image: url(j\61vascript:alert(1));
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('javascript')));
      });

      test('CSS XSS: prevents </style> injection', () {
        const html = '''
<style>
  .x { color: red; }
</style><script>alert(1)</script>
<div>X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('<script')));
        expect(result, contains('<style>'));
        expect(result, contains('color: red'));
      });

      test('CSS XSS: blocks svg javascript in css url()', () {
        const html = '''
<style>
  .x {
    background: url("data:image/svg+xml,<svg onload=alert(1)></svg>");
  }
</style>
<div class="x">X</div>
''';

        final result = sanitizer.sanitize(html);

        expect(result, isNot(contains('onload')));
      });
    });
  });
}
