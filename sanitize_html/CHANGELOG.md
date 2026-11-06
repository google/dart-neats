## v2.3.0
Behaviour changes for every caller, including the deprecated version 2
parameters:
 * Elements the rules do not allow are now _unwrapped_: their tags are
   removed and their content is kept. Content of `script`, `style`,
   `template` and other elements a browser never renders as text is still
   removed. Use `HtmlRewriter.dropElements(...)` to remove subtrees.
 * Output is normalized: tag and attribute names are lower-case, attribute
   values are double-quoted and escaped, void elements are written without
   `/`, unclosed elements are closed and elements the HTML tree builder would
   close are closed.
 * `addLinkRel` sets the `rel` of each link to what the callback returns,
   replacing any `rel` the author wrote.
 * `rel` is kept only with link types that describe the link (`nofollow`,
   `noopener`, `noreferrer`, `ugc`, `sponsored`, `external`, `help`); `name`,
   `target`, `accesskey`, `tabindex`, `aria-describedby`, `aria-labelledby`,
   `color`, `vspace`, `cellpadding`, `cellspacing`, `h7` and `h8` are no
   longer kept; `img[loading]`, `<picture>`, `<source srcset>` and `<section>`
   are.

New API:
 * `sanitizeHtml` takes `rules`, `rewriters` and `tokenizer`. The version 2
   parameters `allowElementId`, `allowClassName` and `addLinkRel` are
   deprecated and cannot be combined with `rules` or `rewriters`.
 * `RuleSet`, `ElementRule`, `ElementPattern` and `AttributeRule` (`any`,
   `url`, `srcset`, `rel`, `where`) declare which elements and attributes are
   kept, composed with `union`, `without`, `restrict` and `withExemptions`.
   `RuleSet()` refuses rules that could let through script, control over the
   page or an unchecked URL; `RuleSet.unsafe()` does not.
 * `RuleSet.gfm()`, the rules for rendered Markdown, following html-pipeline
   v3 and what `package:markdown` emits; `RuleSet.html()`, the rules for
   arbitrary HTML, following Google's safevalues sanitizer; and the
   exemptions `ElementPattern.checkbox()` and
   `ElementPattern.iframe(where:, sandbox:)`.
 * `HtmlRewriter` with `rewriteAttributes`, `addLinkRel`, `prefixIds`,
   `dropClasses`, `dropElements`, `impliedEndTags` and `sanitizer`, composed
   with `fuse`, for changes to the input before the rules are applied.
 * `HtmlTokenizer` (`streaming`, `simple`, `dom`), `HtmlTokenSink` and
   `htmlWriter` for custom pipelines.
 * `package:html` is only used by `HtmlTokenizer.dom`.

## v2.2.0
 * Allow the `<picture>` and `<source>` elements, with `srcset` on `<source>`,
   matching the [`html-pipeline` allowlist](https://github.com/gjtorikian/html-pipeline/blob/main/lib/html_pipeline/sanitization_filter.rb)
   this package is modeled on. Enables theme-aware images via `<picture>` with
   `prefers-color-scheme`.

## v2.1.0
 * Remove custom HTML rendering logic in favor of logic from `package:html`.
 * Added `topics` to `pubspec.yaml`.
 * `rel` attributes added through `addLinkRel` are appended to existing ones.

## v2.0.0
 * Migrate to null safety.

## v1.4.1
 * Make `addLinkRel` optional. [Issue](https://github.com/google/dart-neats/issues/71).

## v1.4.0
 * Added `addLinkRel` option to `sanitize_html`. This will allow users to
   [qualify outbound links](https://support.google.com/webmasters/answer/96569)
   which may [help prevent comment spam](https://support.google.com/webmasters/answer/81749).

## v1.3.0
 * Only print self-closing tags for
   [void-elements](https://www.w3.org/TR/html5/syntax.html#void-elements).
   This could cause `<strong />` in HTML documents, which is can be interpreted
   as an opening tag by HTML5 parsers, causing the HTML structure to break.

## v1.2.0
 * Does not depend on `universal_html`, uses custom HTML rendering for the output.
 * Allowed classes are kept, even if there are non-allowed classes present on the same element.

## v1.1.0
 * Add options `allowElementId` and `allowClassName` to allow specific element
   ids and class names.

## v1.0.0
 * Initial release.
