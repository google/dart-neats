HTML Sanitizer for Dart
=======================

When embedding HTML from an untrusted source in a website it is important to
sanitize the HTML to prevent injection of untrusted JavaScript (XSS exploits).
This package provides a simple function sanitizing HTML to prevent XSS exploits
and limit interference with other elements on the page.

**Disclaimer:** This is not an officially supported Google product.

```dart
import 'package:sanitize_html/sanitize_html.dart' show sanitizeHtml;

void main() {
  print(sanitizeHtml('<a href="javascript:alert();">evil link</a>'));
  // Prints: <a>evil link</a>
  // Which is a lot less evil :)
}
```

By default elements and attributes are filtered with `RuleSet.gfm()`: the
allowlist of [html-pipeline][1], the open-source origin of GitHub's
Markdown pipeline, plus what [`package:markdown`][2] emits for
`ExtensionSet.gitHubWeb`. This removes all inline JavaScript, CSS,
`<form>`, and other elements that could be used for XSS. The rules are
stricter than XSS alone requires, because sanitized HTML must also not
interfere with the page it is inserted into: `id` only with the
`user-content-` prefix, no `name`, `class` only with `markdown-*` tokens
(and `language-*` on `<code>`), no CSS.

Rules and rewriters are optional parameters:

```dart
final safe = sanitizeHtml(
  untrusted,
  rewriters: [
    HtmlRewriter.prefixIds('user-content-'),
    HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow']),
  ],
);
```

Two rule sets and two exemptions are provided:

 * `RuleSet.gfm()` — rendered Markdown, raw HTML included (the default).
 * `RuleSet.html()` — arbitrary HTML: the element and attribute tables of
   Google's [safevalues][3] sanitizer, which keeps whatever cannot reach
   outside the sanitized content. No `id`, `name`, `class`, `<iframe>`,
   `<form>` or controls that could be typed into or submitted; add what the
   host can afford with `union`.
 * `ElementPattern.iframe(where: ..., sandbox: ...)` and
   `ElementPattern.checkbox()` — exemptions to add to either with
   `withExemptions`.

## Rules

A `RuleSet` declares which elements are allowed and, for each, which
attributes and how their values are filtered. Elements without a rule are
_unwrapped_ — their tags go, their content stays and is judged on its own;
attributes without a rule are removed. Rules decide what is safe to keep,
not what the output should look like: to remove whole subtrees, run
`HtmlRewriter.dropElements(tagNames: {...})` before the rules.

```dart
final rules = RuleSet.gfm()
    .union(RuleSet({
      'video': ElementRule(attributes: {
        'src': AttributeRule.url(),
        'controls': AttributeRule.any(),
      }),
    }))
    .withExemptions([
      ElementPattern.iframe(
        where: (src) => src.host == 'www.youtube.com',
        sandbox: {'allow-scripts', 'allow-same-origin'},
      ),
    ]);
```

An `AttributeRule` only ever keeps or drops a value; it never rewrites. So
`union` keeps what either rule set keeps, `without` drops elements, and
`restrict` tightens the attributes of one element, with no surprises. Where an element is acceptable only in one exact form —
`<input>` as a checkbox, `<iframe>` from one origin and sandboxed — an
`ElementPattern` names that form as an exemption: judged on the element as
written, tried before the rule, never merged with anything. Rewriting — adding
`rel="ugc"` to links, prefixing ids, keeping a few class tokens, removing
subtrees — is done by `HtmlRewriter`s (`addLinkRel`, `prefixIds`,
`dropClasses`, `dropElements`, `rewriteAttributes`, or your own `HtmlTokenSink`),
which run before the rules and therefore cannot add anything the rules
would not allow.

`RuleSet(...)` refuses grants that defeat the purpose of sanitizing: `script`, `style`, `base`, `meta`, `link`, `form`, `svg`,
`math`, ... as elements; `on*`, `style`, `srcdoc`, `is`, `form*`, `ping`, ...
as attributes; URL attributes (`href`, `src`, `cite`, ...) bound to anything
but `AttributeRule.url` (`srcset` to `AttributeRule.srcset`); and `rel` bound
to anything but `AttributeRule.rel`, which never admits `opener`.
`RuleSet.unsafe(...)` waives these checks for callers who have reviewed what
they allow.

## The guarantee

Whatever the input, the output of a sanitizer:

 * contains only elements and attributes its `RuleSet` allows, with values
   its `AttributeRule`s kept,
 * never contains comments, doctypes, CDATA sections, or any text that an
   HTML parser can interpret as markup,
 * is balanced: every start tag is closed, at most 128 levels deep.

A browser parsing the output creates **no element and no attribute that is
not in it**. The tree builder may still re-nest misnested formatting elements
and insert implied `tbody`, `tr`, `colgroup` or `p` elements, and a rule set
that allows `plaintext` or `xmp` will see the browser turn later markup into
text; but nothing new appears. With a `RuleSet()` built with the default
checks, no script runs in the page's origin, nothing in the content can
navigate the page, and no URL has a scheme other than `http`, `https` or
`mailto`.

The output is safe when inserted where the HTML parser is in its _data
state_: as content of `<body>`, `<div>`, etc. in an HTML document. It is
**not** safe inside an attribute value, `<script>`, `<style>`, `<textarea>`,
`<title>`, `<svg>`, `<math>`, or an XML document.

The guarantee is about script execution and markup injection. It does not
make content trustworthy: links can still point to malicious sites, images
can still track viewers, and text can still deceive. And it says nothing
about scripts the host page runs over the output: client-side template
frameworks that evaluate attributes (`x-on:click`, `v-on:click`, `ng-click`,
`hx-get`, ...) must not be mounted on a container holding sanitized HTML
unless the rules are known not to allow such attributes (the GFM rules do
not).

## How it works, and what is trusted

Most sanitizers try to recognize dangerous input, which means they must
model every quirk of every HTML parser. This package instead only ever
_produces_ output from a small, closed grammar in which text cannot become
markup. The HTML tokenizer only creates tags from a raw `<` in its data state;
the writer never emits a raw `<`, always double-quotes attribute values with
`"` escaped, and restricts tag and attribute names to a safe alphabet. That
is the whole argument; it does not depend on how the input was parsed.

```
input ─► HtmlTokenizer ─► HtmlRewriter.impliedEndTags() ─► rewriters ─► HtmlRewriter.sanitizer(rules) ─► htmlWriter ─► output
         (untrusted)      (untrusted)                    (untrusted)   (trusted)                       (trusted)
```

Everything between tokenizer and writer is an `HtmlRewriter`; `HtmlTokenizer`,
`HtmlTokenSink` and `htmlWriter` are exported too, for custom pipelines.

The **trusted base** is small and reviewable:

 * [`lib/src/html_writer.dart`](lib/src/html_writer.dart): the only
   code that writes output. Documents the tokenizer-state argument with
   references to the HTML specification.
 * [`lib/src/url_policy.dart`](lib/src/url_policy.dart): which URLs may appear
   in URL attributes, and why `Uri.parse` is not used.
 * [`lib/src/attribute_rule.dart`](lib/src/attribute_rule.dart),
   [`lib/src/element_rule.dart`](lib/src/element_rule.dart),
   [`lib/src/element_pattern.dart`](lib/src/element_pattern.dart),
   [`lib/src/rule_set.dart`](lib/src/rule_set.dart): how rules are applied.
 * [`lib/src/grant_assertions.dart`](lib/src/grant_assertions.dart): what a
   checked `RuleSet` refuses, and why.
 * [`lib/src/rules/`](lib/src/rules/): the default allowlists `gfm.dart`,
   `html.dart` and `link_types.dart` (policy data, no logic that affects
   escaping), each rule annotated with its source.
 * [`lib/src/sanitizer.dart`](lib/src/sanitizer.dart): applies the rule set.
   Trusted for completeness: every start tag must go through the rules; a
   forwarding bug there would bypass them.

Everything else is **untrusted** in the sense that a bug there can make
output uglier (markup shown as text, content lost) but never unsafe:

 * `lib/src/util/`: ASCII and space-separated-token helpers.
 * `lib/src/tokenizer/`: three interchangeable tokenizers.
   `HtmlTokenizer.streaming` (default) follows the WHATWG tokenizer states
   without building a tree; `HtmlTokenizer.simple` is a small tokenizer for
   well-formed input; `HtmlTokenizer.dom` parses a full tree with
   `package:html` and handles misnested markup like a browser, at several
   times the cost (and `package:html`'s tree builder is superlinear on deeply
   nested input, so prefer the streaming tokenizers for input of unbounded
   size).
 * `lib/src/html_rewriter.dart`, `lib/src/delegating_html_token_sink.dart`:
   the rewriter class and the forwarding base of rewriter sinks.
 * `lib/src/rewriters/`: the built-in `HtmlRewriter`s —
   `implied_end_tags.dart` (the tree builder's implied end tags, so sloppy
   input gives tidy output), `attributes.dart`, `prefix_ids.dart`,
   `drop_classes.dart`, `drop_elements.dart`.

Because the writer escapes attribute values exactly, the URL policy and the
browser's URL parser see identical strings (up to the HTML parser's
CR/LF/NUL input preprocessing, which cannot change a verdict); the
tokenizers' character reference decoding therefore is not security relevant
either.

[1]: https://github.com/gjtorikian/html-pipeline/blob/c99d76dbfe817598387c371af342e25abdccd363/lib/html_pipeline/sanitization_filter.rb
[2]: https://pub.dev/packages/markdown
[3]: https://github.com/google/safevalues/blob/main/src/builders/html_sanitizer/sanitizer_table/default_sanitizer_table.ts
