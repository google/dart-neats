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

import 'package:checks/checks.dart';
import 'package:test/test.dart';

import 'package:typed_sql/src/utils/snake_case.dart';

final _testCases = <String, String>{
  // --- Standard / Base Cases ---
  '': '',
  'user': 'user',
  'user_id': 'user_id', // Already snake_case
  'authorId': 'author_id',
  'createdAt': 'created_at',
  'isSuperUserStatus': 'is_super_user_status',

  // --- Single Letter Acronyms / Words ---
  'UserVCount': 'user_v_count',
  'vCount': 'v_count',
  'aValueB': 'a_value_b',

  // --- Effective Dart Compliant Acronyms ---
  'dbConnection': 'db_connection',
  'jsonParser': 'json_parser',
  'HttpSftp': 'http_sftp',
  'UserIdIp': 'user_id_ip', // Using 'Id' and 'Ip' as words
  'XmlHttpRequest': 'xml_http_request',

  // --- Non-Compliant Acronyms (Trailing) ---
  'userID': 'user_id',
  'userIP': 'user_ip',
  'connectionURL': 'connection_url',

  // --- Non-Compliant Acronyms (Leading) ---
  'HTMLParser': 'html_parser',
  'IPAddress': 'ip_address',

  // --- Non-Compliant Acronyms (Middle) ---
  'userIPCount': 'user_ip_count',
  'parseXMLStream': 'parse_xml_stream',
  'useHTTPSFTPProtocol': 'use_httpsftp_protocol', // All-caps >2 letters trap
  // --- Numbers as Boundaries ---
  'addressLine1': 'address_line1', // Number at end
  'address1Line': 'address1_line', // Number splitting words
  'oauth2ID': 'oauth2_id', // Number before acronym
  'player123Score': 'player123_score',
  '25DaysLater': '25_days_later', // Starting with number
  // --- Expected Edge Case Limitations (Jammed Acronyms) ---
  // These assert the known limitations of the regex strategy
  'UserIDIP': 'user_idip',
  'userXMLHTTP': 'user_xmlhttp',
  'XMLHTTPRequest': 'xmlhttp_request',

  // --- PascalCase (Classes/Types) ---
  'UserEntity': 'user_entity',
  'ShoppingCartItem': 'shopping_cart_item',

  // --- All Caps ---
  'USER': 'user',
  'ID': 'id',
};

void main() {
  group('snakeCase conversion tests', () {
    for (final entry in _testCases.entries) {
      final input = entry.key;
      final expected = entry.value;

      test('snakeCase("$input") -> "$expected"', () {
        check(snakeCase(input)).equals(expected);
      });
    }
  });
}
