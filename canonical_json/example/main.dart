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

import 'package:canonical_json/canonical_json.dart';

void main() {
  // Encode a message
  final bytes = canonicalJson.encode({
    'from': 'alice',
    'message': 'Hi Bob',
  });

  // Decode message
  try {
    final msg = canonicalJson.decode(bytes) as Map<String, Object>;
    print('message is: ${msg['message']}');
  } on InvalidCanonicalJsonException {
    print('Message was not canonical JSON!');
  }
}
