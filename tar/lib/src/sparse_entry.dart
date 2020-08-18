// Copyright 2020
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

/// Represents a [length]-sized fragment at [offset] in a file.
///
/// [SparseEntry]s can represent either data or holes, and we can easily
/// convert between the two if we know the size of the file, all the sparse
/// data and all the sparse entries combined must give the full size.
class SparseEntry {
  final int offset;
  final int length;

  SparseEntry(this.offset, this.length);

  int get end => offset + length;

  @override
  String toString() => 'offset: $offset, length $length';

  @override
  bool operator ==(other) {
    if (other is! SparseEntry) return false;

    return offset == other.offset && length == other.length;
  }

  @override
  int get hashCode => offset ^ length;
}
