// Copyright 2021 Google LLC
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

/// Signature of a function creating a buffer.
///
/// The buffer returned must be growable.
///
/// Depending on the input stream to buffer, a custom [BufferFactory] can be
/// provided to improve memory efficiency. For instance, a [Uint8Buffer][uib]
/// from the `typed_data` package can be suitable when operating on byte-
/// streams.
///
/// When no custom [BufferFactory] is provided, this package will use the
/// default [List] implementation.
///
/// [uib]: https://pub.dev/documentation/typed_data/latest/typed_data.typed_buffers/Uint8Buffer-class.html
typedef BufferFactory<T> = List<T> Function();
