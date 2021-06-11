## v2.0.0-dev
 * Remove custom HTML rendering logic in favor of logic from `package:html`.

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
