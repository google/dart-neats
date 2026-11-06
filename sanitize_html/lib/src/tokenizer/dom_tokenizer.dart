// Copyright 2026 Google LLC
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

/// A tokenizer backed by the `package:html` tree builder, so misnested input
/// is reported as a browser would structure it.
library;

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parseFragment;

import 'streaming_tokenizer.dart';

import '../html_token_sink.dart';
import '../html_writer.dart' show isVoidElement;
import 'elements.dart';

/// See `HtmlTokenizer.dom`.
void tokenizeDom(String html, HtmlTokenSink sink) {
  final DocumentFragment fragment;
  try {
    fragment = parseFragment(html);
  } on FormatException {
    // package:html throws on numeric character references beyond 2^63
    // (`&#9223372036854775808;`); the streaming tokenizer handles them.
    tokenizeStreaming(html, sink);
    return;
  }
  // Iterative walk; each frame is a node and the index of its next child.
  final stack = <(Node, int)>[(fragment, 0)];
  while (stack.isNotEmpty) {
    final (node, index) = stack.removeLast();
    if (index < node.nodes.length) {
      stack.add((node, index + 1));
      final child = node.nodes[index];
      if (child is Text) {
        // The sink expects undecoded text; re-encode the one character that
        // can begin a reference.
        final text = child.data.replaceAll('&', '&amp;');
        sink.text(text, 0, text.length);
      } else if (child is Element) {
        final name = child.localName!.toLowerCase();
        sink.startTag(
          name,
          {
            for (final MapEntry(:key, :value) in child.attributes.entries)
              key.toString().toLowerCase(): value,
          },
        );
        // The tree builder drops a newline right after these start tags;
        // put it back when the next one would otherwise be dropped too, so
        // that sanitizing the output again does not lose another line.
        // https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inbody
        if (child.nodes case [Text(:final data), ...]
            when (name == 'pre' || name == 'listing') &&
                data.startsWith('\n')) {
          sink.text('\n', 0, 1);
        }
        // The streaming tokenizers never emit the content of RAWTEXT,
        // RCDATA and script elements as text; do the same so that an
        // unwrapped `<script>` does not leave its code behind as text.
        stack.add((
          child,
          contentlessElements.contains(name) ? child.nodes.length : 0
        ));
      }
    } else if (node is Element) {
      final name = node.localName!.toLowerCase();
      if (!isVoidElement(name)) {
        sink.endTag(name);
      }
    }
  }
  sink.close();
}
