import 'dart:io';

import 'package:sanitize_html/src/sane_html_validator.dart';

final List<String> sampleHtmlDocuments = [
  // Short HTML
  '<p>Hello <strong>world</strong></p>',
  // Medium HTML
  '''
  <div>
    <p onclick="alert(1)">Click me</p>
    <img src="javascript:evil()" />
    <a href="https://example.com" onclick="hack()">link</a>
  </div>
  ''',
  // Large HTML
  File('benchmark/fixtures/large_email_1.html').readAsStringSync(),
  File('benchmark/fixtures/large_email_2.html').readAsStringSync(),
];

void main() {
  const iterations = 200;

  final sane = SaneHtmlValidator(
    allowElementId: null,
    allowClassName: null,
    addLinkRel: null,
    allowAttributes: null,
    allowTags: null,
  );

  _warmup(sane);

  final saneDuration =
      _benchmark('SaneHtmlValidator', sane.sanitize, iterations);

  final saneMs = saneDuration.inMilliseconds;

  print('--- Benchmark result ---');
  print('SaneHtmlValidator  : $saneMs ms');
}

void _warmup(
  SaneHtmlValidator sane,
) {
  for (final html in sampleHtmlDocuments) {
    sane.sanitize(html);
  }
}

Duration _benchmark(
  String label,
  String Function(String) sanitize,
  int iterations,
) {
  final sw = Stopwatch()..start();

  for (var i = 0; i < iterations; i++) {
    for (final html in sampleHtmlDocuments) {
      sanitize(html);
    }
  }

  sw.stop();
  print('$label finished in ${sw.elapsed.inMilliseconds} ms');
  return sw.elapsed;
}
