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

import 'package:test/test.dart';
import 'package:pem/pem.dart';
import 'testcases.dart';

final _labelToString = <PemLabel, String>{
  PemLabel.certificate: 'certificate',
  PemLabel.certificateRevocationList: 'certificateRevocationList',
  PemLabel.certificateRequest: 'certificateRequest',
  PemLabel.pkcs7: 'pkcs7',
  PemLabel.cms: 'cms',
  PemLabel.privateKey: 'privateKey',
  PemLabel.encryptedPrivateKey: 'encryptedPrivateKey',
  PemLabel.attributeCertificate: 'attributeCertificate',
  PemLabel.publicKey: 'publicKey',
};

void main() {
  group('decodePemBlocks (non-strict)', () {
    for (final label in PemLabel.values) {
      test(_labelToString[label], () {
        final blocks = decodePemBlocks(label, strictTestCases);
        expect(blocks, hasLength(greaterThanOrEqualTo(1)));
      });
    }

    test('multiple certificate', () {
      // The testCases has 2 certificates.
      final blocks = decodePemBlocks(PemLabel.certificate, strictTestCases);
      expect(blocks, hasLength(equals(2)));
    });

    test('unsafeIgoreLabels', () {
      final blocks = decodePemBlocks(
        PemLabel.certificate,
        strictTestCases,
        unsafeIgnoreLabel: true,
      );
      expect(blocks, hasLength(equals(10)));
    });
  });

  group('decodePemBlocks (strict)', () {
    for (final label in PemLabel.values) {
      test(_labelToString[label], () {
        final blocks = decodePemBlocks(label, strictTestCases, strict: true);
        expect(blocks, hasLength(greaterThanOrEqualTo(1)));
      });
    }

    test('multiple certificate', () {
      // The testCases has 2 certificates.
      final blocks = decodePemBlocks(
        PemLabel.certificate,
        strictTestCases,
        strict: true,
      );
      expect(blocks, hasLength(equals(2)));
    });

    test('unsafeIgoreLabels', () {
      final blocks = decodePemBlocks(
        PemLabel.certificate,
        strictTestCases,
        strict: true,
        unsafeIgnoreLabel: true,
      );
      expect(blocks, hasLength(equals(10)));
    });
  });

  group('decodePemBlocks (non-strict) with extra whitespace', () {
    for (final label in PemLabel.values) {
      test(_labelToString[label], () {
        final blocks = decodePemBlocks(label, laxTestCases);
        expect(blocks, hasLength(greaterThanOrEqualTo(1)));
      });
    }

    test('multiple certificate', () {
      // The laxTestCases has 2 certificates.
      final blocks = decodePemBlocks(PemLabel.certificate, laxTestCases);
      expect(blocks, hasLength(equals(2)));
    });

    test('unsafeIgoreLabels', () {
      final blocks = decodePemBlocks(
        PemLabel.certificate,
        laxTestCases,
        unsafeIgnoreLabel: true,
      );
      expect(blocks, hasLength(equals(10)));
    });

    test('laxTestCases matches strictTestCases', () {
      final laxblocks = decodePemBlocks(
        PemLabel.certificate,
        laxTestCases,
        unsafeIgnoreLabel: true,
      );
      final strictblocks = decodePemBlocks(
        PemLabel.certificate,
        strictTestCases,
        strict: true,
        unsafeIgnoreLabel: true,
      );
      expect(laxblocks, equals(strictblocks));
    });
  });

  group('PemCodec.decode + PemCodec.encode / PemCodec.decode (strict)', () {
    for (final label in PemLabel.values) {
      test(_labelToString[label], () {
        final codec = PemCodec(label);
        final data = codec.decode(strictTestCases);
        expect(data, isNotNull);
        final pem = codec.encode(data);
        final strictCodec = PemCodec(label, strict: true);
        final data2 = strictCodec.decode(pem);
        expect(data2, equals(data));
      });
    }
  });
}
