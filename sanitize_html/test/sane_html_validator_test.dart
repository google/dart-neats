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

        test('invalid URLs removed (javascript:)', () {
          final out =
              validator.sanitize('<a href="javascript:alert(1)">Bad</a>');
          expect(out.contains('href='), false);
        });

        test('valid base64 and CID images allowed', () {
          final out = validator.sanitize('''
          <img src="cid:123">
          <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA">
        ''');

          expect(out.contains('cid:123'), true);
          expect(out.contains('data:image/png;base64'), true);
        });

        test('invalid base64 images removed', () {
          final out = validator.sanitize(
            '<img src="data:image/png;base64,INVALID@!"/>',
          );
          expect(out.contains('<img>'), true);
        });

        test('invalid image URLs removed', () {
          final out = validator.sanitize('<img src="javascript:evil()"/>');
          expect(out.contains('<img>'), true);
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

        expect(out.contains('<svg'), false);
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

      test('strip CDATA containing JS inside SVG', () {
        const html = '''
      <svg>
        <![CDATA[
          alert("XSS");
        ]]>
        <circle cx="50" cy="50" r="40"/>
      </svg>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('CDATA'), false);
        expect(out.contains('alert'), false);
        expect(out.contains('<svg'), false);
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

      test('inline CSS with base64 SVG payload is removed or neutralized', () {
        const html = '''
      <p style="background-image:url(data:image/svg+xml;base64,PHN2ZyBvbmxvYWQ9YWxlcnQoMSk+)">
        Hi
      </p>
    ''';

        final out = validator.sanitize(html);

        expect(out.contains('data:image/svg+xml'), false);
        expect(out.contains('base64,'), false);
        expect(out.contains('alert('), false);
        expect(out.contains('Hi'), true);
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
  });
}
