// Copyright 2025 Google LLC
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

/// API for implementation of custom [DatabaseAdapter] for `package:typed_sql`.
///
/// You should only ever need to import this library, if you are implementing
/// a custom [DatabaseAdapter].
///
/// > [!WARNING]
/// > This interface is NOT stable yet, while subclasses of [DatabaseAdapter]
/// > is possible outside `package:typed_sql`, newer versions of this package
/// > may add new methods (remove existing) without a major version bump!
///
/// @docImport 'package:typed_sql/typed_sql.dart';
@experimental
library;

import 'package:meta/meta.dart';

export 'src/adapter/adapter.dart';
