// Copyright 2023 Google LLC
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
import 'package:dartdoc_test/dartdoc_test.dart';

/// Test code samples in documentation comments in this package.
///
/// It extracts code samples from documentation comments in this package and
/// analyzes them. If there are any errors in the code samples, the test will fail
/// and you can see the problems details.
///
/// If you want to test only specific files, you can use [include] and [exclude]
/// options.
void main() => runDartdocTest();
