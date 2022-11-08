// Copyright 2019 Google LLC
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

/// Utilities for decoding/encoding PEM as specified in [RFC 7468][1].
///
/// Decoding methods in this package follow [RFC 7468][1] and ignore text
/// around the PEM block. This package does not attempt to distinguish between
/// malformed PEM blocks and surrounding text that should be ignored. Thus, no
/// decoding method in this package will throw exceptions for malformed PEM
/// blocks, the [PemCodec] will however throw if there is no PEM blocks present.
///
/// By default decoding methods in this package ignore extra whitespace, tabs,
/// and line breaks as specified for lax-mode in [RFC 7468][1]. While encoding
/// always produces strict-mode output. This aims to maximize interoperability
/// with minimal risks of misinterpreting the input.
///
/// To avoid inappropriate confusion of different types of entities decoding
/// methods in this package requires a [PemLabel] to be specified, and ignores
/// PEM blocks without matching labels. A flag `unsafeIgnoreLabel` can be
/// provided to these methods to ignore the labels, however, this is strongly
/// discouraged.
///
/// **Example**
/// ```dart
/// import 'package:pem/pem.dart';
///
/// // Parse PEM encoded private key.
/// List<int> keyData = PemCodec(PemLabel.privateKey).decode("""
///   -----BEGIN PRIVATE KEY-----
///   MIGEAgEAMBAGByqGSM49AgEGBSuBBAAKBG0wawIBAQQgVcB/UNPxalR9zDYAjQIf
///   jojUDiQuGnSJrFEEzZPT/92hRANCAASc7UJtgnF/abqWM60T3XNJEzBv5ez9TdwK
///   H0M6xpM2q+53wmsN/eYLdgtjgBd3DBmHtPilCkiFICXyaA8z9LkJ
///   -----END PRIVATE KEY-----
/// """);
///
/// // Encode keyData as PEM string.
/// String pemBlock = PemCodec(PemLabel.privateKey).encode(keyData);
///
/// // Print encoded block (should print what we parsed, without indentation)
/// print(pemBlock);
/// ```
///
/// To parse a series of concatenated PEM strings as often happens when giving
/// a list of certificates see [decodePemBlocks].
///
/// [1]: https://tools.ietf.org/html/rfc7468
library pem;

import 'dart:convert' show base64, Codec, Converter;
import 'dart:math' as math;
import 'package:petitparser/petitparser.dart';

import 'src/parser.dart' show stricttextualmsg, laxtextualmsg;

/// Labels for PEM encoded strings.
///
/// **Example**, a PEM encoded string using [PemLabel.publicKey] will look as
/// follows.
/// ```
/// -----BEGIN PUBLIC KEY-----
/// MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEn1LlwLN/KBYQRVH6HfIMTzfEqJOVztLe
/// kLchp2hi78cCaMY81FBlYs8J9l7krc+M4aBeCGYFjba+hiXttJWPL7ydlE+5UG4U
/// Nkn3Eos8EiZByi9DVsyfy9eejh+8AXgp
/// -----END PUBLIC KEY-----
/// ```
///
/// The `PemCodec` requires a [PemLabel] to ensure that bytes decoded matches
/// the intended use-case.
///
/// See [section 4 RFC 7468](https://tools.ietf.org/html/rfc7468#section-4).
enum PemLabel {
  /// Public-key certificate (`'CERTIFICATE'`).
  ///
  /// See [section 5 RFC 7468](https://tools.ietf.org/html/rfc7468#section-5).
  certificate,

  /// Certificate Revocation List (`'X509 CRL'`).
  ///
  /// See [section 6 RFC 7468](https://tools.ietf.org/html/rfc7468#section-6).
  certificateRevocationList,

  /// PKCS #10 Certification Request (`'CERTIFICATE REQUEST'`).
  ///
  /// See [section 7 RFC 7468](https://tools.ietf.org/html/rfc7468#section-7).
  certificateRequest,

  /// PKCS #7 Cryptographic Message Syntax structure (`'PKCS7'`).
  ///
  /// See [section 8 RFC 7468](https://tools.ietf.org/html/rfc7468#section-8).
  pkcs7,

  /// Cryptographic Message Syntax structure (`'CMS'`).
  ///
  /// See [section 9 RFC 7468](https://tools.ietf.org/html/rfc7468#section-9).
  cms,

  /// Unencrypted PKCS #8 Private Key Information Syntax structure
  /// (`'PRIVATE KEY'`).
  ///
  /// See [section 10 RFC 7468](https://tools.ietf.org/html/rfc7468#section-10).
  privateKey,

  /// Encrypted PKCS #8 Private Key Information Syntax structure
  /// (`'ENCRYPTED PRIVATE KEY'`).
  ///
  /// See [section 11 RFC 7468](https://tools.ietf.org/html/rfc7468#section-11).
  encryptedPrivateKey,

  /// Attribute certificate (`'ATTRIBUTE CERTIFICATE'`).
  ///
  /// See [section 12 RFC 7468](https://tools.ietf.org/html/rfc7468#section-12).
  attributeCertificate,

  /// Subject Public Key Info (`'PUBLIC KEY'`).
  ///
  /// See [section 13 RFC 7468](https://tools.ietf.org/html/rfc7468#section-13).
  publicKey,
}

/// Map from [PemLabel] to strict label name, following by non-strict label
/// names if any is permitted,
const _labels = <PemLabel, List<String>>{
  PemLabel.certificate: ['CERTIFICATE'],
  PemLabel.certificateRevocationList: ['X509 CRL'],
  PemLabel.certificateRequest: [
    'CERTIFICATE REQUEST',
    'NEW CERTIFICATE REQUEST',
  ],
  PemLabel.pkcs7: ['PKCS7'],
  PemLabel.cms: ['CMS'],
  PemLabel.privateKey: ['PRIVATE KEY'],
  PemLabel.encryptedPrivateKey: ['ENCRYPTED PRIVATE KEY'],
  PemLabel.attributeCertificate: ['ATTRIBUTE CERTIFICATE'],
  PemLabel.publicKey: ['PUBLIC KEY'],
};

/// Decode a [String] of one or more concatenated PEM blocks.
///
/// Returns a list of base64 decoded bytes for each PEM block matching the
/// given [label].  An empty list if no correctly formatted PEM blocks is found
/// in the given [pemString]. This method will not throw an exception on
/// formatting errors.
///
/// The parser defaults to `laxtextualmsg` from [RFC 7468][1],
/// but if [strict] is `true` parser will require `stricttextualmsg`.
/// It is generally safe to parse in non-strict mode, which just
/// ignores whitespace and allows widely used label aliases.
///
/// If [unsafeIgnoreLabel] is set to `true` the decoding parser will ignore
/// the label. This can be useful in certain legacy scenarios, but is
/// generally discouraged as it could lead to unintended usages of keys.
///
/// ***Example**
/// ```dart
/// import 'package:pem/pem.dart';
///
/// // Parse in non-strict mode (default) which ignores extra whitespace.
/// final blocks = decodePemBlocks(PemLabel.publicKey, """
/// -----BEGIN PUBLIC KEY-----
/// MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEn1LlwLN/KBYQRVH6HfIMTzfEqJOVztLe
/// kLchp2hi78cCaMY81FBlYs8J9l7krc+M4aBeCGYFjba+hiXttJWPL7ydlE+5UG4U
/// Nkn3Eos8EiZByi9DVsyfy9eejh+8AXgp
/// -----END PUBLIC KEY-----
///
///   -----BEGIN PUBLIC KEY-----
///   MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEn1LlwLN/KBYQRVH6HfIMTzfEqJOVztLe
///   kLchp2hi78cCaMY81FBlYs8J9l7krc+M4aBeCGYFjba+hiXttJWPL7ydlE+5UG4U
///   Nkn3Eos8EiZByi9DVsyfy9eejh+8AXgp
///   -----END PUBLIC KEY-----
/// """);
///
/// // Print byte size of keys
/// print('1st public key has ${blocks[0].length} bytes');
/// print('2nd public key has ${blocks[1].length} bytes');
/// ```
///
/// [1]: https://tools.ietf.org/html/rfc7468
List<List<int>> decodePemBlocks(
  PemLabel label,
  String pemString, {
  bool strict = false,
  bool unsafeIgnoreLabel = false,
}) {
  final labels = _labels[label];
  if (labels == null) {
    throw AssertionError('Unkown label');
  }

  // Pick a parser
  final p = strict ? stricttextualmsg : laxtextualmsg;

  // Create results
  final result = <List<int>>[];
  for (final r in p.matchesSkipping(pemString)) {
    final doc = r.cast<String>();
    final preLabel = doc[0];
    final data = doc[1];
    final postLabel = doc[2];

    // Pre and post label must match, unless we're in unsafe ignore label mode.
    if (preLabel != postLabel && !unsafeIgnoreLabel) {
      continue;
    }
    // Label much match an allowed alias, if not ignoring
    if (!labels.contains(preLabel) && !unsafeIgnoreLabel) {
      continue;
    }
    // Label much match canonical label name, if we're in strict mode
    if (strict && labels.first != preLabel && !unsafeIgnoreLabel) {
      continue;
    }

    try {
      result.add(base64.decode(data));
    } on Exception {
      continue; // Ignore malformed base64
    }
  }

  return result;
}

/// Encode [data] as a PEM block with the given [label].
///
/// Returns a textual string encoding [data] with [label] formatted following
/// `stricttextualmsg` from [RFC 7468][1].
///
/// Arbitrary data may be prepended to lines before a PEM block, and this
/// package will ignore such data when parsing PEM blocks.
///
/// When encoding multiple PEM blocks, such a certificate chain, it is common
/// to simply concatenate the PEM blocks. Towards this end the output of this
/// function can be concatenated with other PEM blocks and parsed with
/// [decodePemBlocks].
///
/// [1]: https://tools.ietf.org/html/rfc7468
String encodePemBlock(PemLabel label, List<int> data) {
  final labels = _labels[label];
  if (labels == null) {
    throw AssertionError('Unkown label');
  }

  final s = StringBuffer();
  final L = labels.first;
  s.writeln('-----BEGIN $L-----');
  final lines = base64.encode(data);
  for (var i = 0; i < lines.length; i += 64) {
    s.writeln(lines.substring(i, math.min(lines.length, i + 64)));
  }
  s.writeln('-----END $L-----');
  return s.toString();
}

/// A [Codec] for encoding and decoding PEM blocks with a given [PemLabel].
///
/// When decoding instances of this class will throw [NoPemBlockFoundException]
/// if no PEM blocks are found. However, if multiple blocks are present the
/// [decoder] will simply return the first.
class PemCodec extends Codec<List<int>, String> {
  final PemLabel label;
  final bool _strict;
  final bool _unsafeIgnoreLabel;

  /// Create a [PemCodec] for encoding/decoding PEM encoded strings with given
  /// [label].
  ///
  /// A [label] is required for encoding values and to ensure that decoded
  /// bytes aren't used in an unintended context.
  ///
  /// When decoding the parser defaults to `laxtextualmsg` from [RFC 7468][1],
  /// but if [strict] is `true` parser will require `stricttextualmsg`.
  /// It is generally safe to parse in non-strict mode, which just
  /// ignores whitespace and allows widely used label aliases.
  ///
  /// If [unsafeIgnoreLabel] is set to `true` the decoding parser will ignore
  /// the label. This can be useful in certain legacy scenarios, but is
  /// generally discouraged as it could lead to unintended usages of keys.
  ///
  /// [1]: https://tools.ietf.org/html/rfc7468
  PemCodec(
    this.label, {
    bool strict = false,
    bool unsafeIgnoreLabel = false,
  })  : _strict = strict,
        _unsafeIgnoreLabel = unsafeIgnoreLabel {
    ArgumentError.checkNotNull(label, 'label');
    ArgumentError.checkNotNull(strict, 'strict');
    ArgumentError.checkNotNull(unsafeIgnoreLabel, 'unsafeIgnoreLabel');
  }

  /// Returns a [Converter] for decoding a single PEM block.
  ///
  /// Unlike [decodePemBlocks] this decoder will throw an exception if no PEM
  /// blocks are found. If multiple blocks is present it decodes the first
  /// block.
  @override
  Converter<String, List<int>> get decoder => _PemDecoder(
        label,
        _strict,
        _unsafeIgnoreLabel,
      );

  /// Return a [Converter] for decoding a single PEM block.
  ///
  /// Blocks are always formatted following `stricttextualmsg` from
  /// [RFC 7468][1].
  ///
  /// [1]: https://tools.ietf.org/html/rfc7468
  @override
  Converter<List<int>, String> get encoder => _PemEncoder(label);
}

class _PemDecoder extends Converter<String, List<int>> {
  final PemLabel _label;
  final bool _strict;
  final bool _unsafeIgnoreLabel;

  const _PemDecoder(this._label, this._strict, this._unsafeIgnoreLabel);

  @override
  List<int> convert(String data) {
    final blocks = decodePemBlocks(
      _label,
      data,
      strict: _strict,
      unsafeIgnoreLabel: _unsafeIgnoreLabel,
    );
    if (blocks.isEmpty) {
      throw NoPemBlockFoundException._(data);
    }
    return blocks.first;
  }
}

class _PemEncoder extends Converter<List<int>, String> {
  final PemLabel _label;

  const _PemEncoder(this._label);

  @override
  String convert(List<int> data) {
    return encodePemBlock(_label, data);
  }
}

/// Thrown by [PemCodec] if no valid PEM blocks was found during decoding.
///
/// As PEM blocks may be precended by lines with arbitrary data, exceptions are
/// not thrown to indicate malformed PEM blocks.
class NoPemBlockFoundException implements Exception {
  final String data;
  NoPemBlockFoundException._(this.data);

  @override
  String toString() => 'No valid PEM blocks was found in the data:\n$data';
}
