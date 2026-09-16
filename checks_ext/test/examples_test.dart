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

/// This library tests that the examples in the `example/` directory
/// produce the output described in their comments.
///
/// Recipe for adding a new example:
/// 1. Create a file `example/your_feature.dart`.
/// 2. Add a `main()` function that demonstrates success and failure.
/// 3. Document the expected output using `//` comments.
///    Lines starting with `///` are treated as documentation and ignored.
/// 4. In the documentation for the feature, add the directive:
///    `/// {@example /example/your_feature.dart}`
///
/// The test extracts the expected output from the comments (lines starting with `//` but not `///`)
/// and verifies that running the example as a standalone script produces that output in stdout or stderr.
library;

import 'check_examples.dart';

void main() => checkExamples();
