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

  static final RegExp _space = RegExp(r'\s');
  static final RegExp _trailingCommas = RegExp(r',+$');

  static List<SrcsetCandidate> parse(String input) {
    final candidates = <SrcsetCandidate>[];
    var pos = 0;
    while (pos < input.length) {
      while (pos < input.length &&
          (_space.hasMatch(input[pos]) || input[pos] == ',')) {
        pos++;
      }
      if (pos >= input.length) break;

      final urlStart = pos;
      while (pos < input.length && !_space.hasMatch(input[pos])) {
        pos++;
      }
      final url = input.substring(urlStart, pos);
      if (url.endsWith(',')) {
        candidates.add(SrcsetCandidate(url.replaceFirst(_trailingCommas, ''), ''));
        continue;
      }

      final descriptorsStart = pos;
      var depth = 0;
      while (pos < input.length && !(input[pos] == ',' && depth == 0)) {
        if (input[pos] == '(') depth++;
        if (input[pos] == ')' && depth > 0) depth--;
        pos++;
      }
      candidates.add(
        SrcsetCandidate(url, input.substring(descriptorsStart, pos).trim()),
      );
      pos++; // skip the separating comma
    }
    return candidates;
  }
}
