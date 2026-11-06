/// A srcset image candidate: [url] plus its raw descriptors (`1x`, `300w`).
class SrcsetCandidate {
  const SrcsetCandidate(this.url, this.descriptors);

  final String url;
  final String descriptors;

  @override
  bool operator ==(Object other) =>
      other is SrcsetCandidate &&
      other.url == url &&
      other.descriptors == descriptors;

  @override
  int get hashCode => url.hashCode ^ descriptors.hashCode;

  @override
  String toString() => 'SrcsetCandidate($url, $descriptors)';
}

/// Splits a `srcset` value into candidates like the WHATWG parsing algorithm:
/// the URL is a run of non-whitespace, so commas inside `data:` or https URLs
/// do not split a candidate.
class SrcsetParser {
  const SrcsetParser._();

  // The browser splits srcset on ASCII whitespace only.
  static final RegExp _space = RegExp(r'[ \t\n\f\r]');

  static List<SrcsetCandidate> parse(String input) {
    final candidates = <SrcsetCandidate>[];
    var pos = _skipSeparators(input, 0);
    while (pos < input.length) {
      final urlEnd = _endOfUrl(input, pos);
      final url = input.substring(pos, urlEnd);
      if (url.endsWith(',')) {
        candidates.add(SrcsetCandidate(_trimTrailingCommas(url), ''));
        pos = _skipSeparators(input, urlEnd);
        continue;
      }

      final descriptorsEnd = _endOfDescriptors(input, urlEnd);
      candidates.add(
        SrcsetCandidate(url, input.substring(urlEnd, descriptorsEnd).trim()),
      );
      pos = _skipSeparators(input, descriptorsEnd);
    }
    return candidates;
  }

  /// A regex like `,+$` backtracks quadratically on a long run of commas.
  static String _trimTrailingCommas(String url) {
    var end = url.length;
    while (end > 0 && url[end - 1] == ',') {
      end--;
    }
    return url.substring(0, end);
  }

  static bool _isSeparator(String char) => char == ',' || _space.hasMatch(char);

  static int _skipSeparators(String input, int pos) {
    while (pos < input.length && _isSeparator(input[pos])) {
      pos++;
    }
    return pos;
  }

  static int _endOfUrl(String input, int pos) {
    while (pos < input.length && !_space.hasMatch(input[pos])) {
      pos++;
    }
    return pos;
  }

  /// Like the browser, parentheses do not nest. The first `)` closes them.
  static int _endOfDescriptors(String input, int pos) {
    var inParens = false;
    while (pos < input.length) {
      final char = input[pos];
      if (char == ',' && !inParens) break;
      if (char == '(') inParens = true;
      if (char == ')') inParens = false;
      pos++;
    }
    return pos;
  }
}
