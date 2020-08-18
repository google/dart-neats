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

import 'package:meta/meta.dart';

/// An exception indicating that there was an issue with parsing a
/// TAR File. Intended to be seen by the user.
@sealed
class TarFileException extends FormatException {
  TarFileException(String message) : super(message);
}

/// An exception indicating that there was an issue with parsing a
/// TAR Header. Intended to be seen by the user.
@sealed
class TarHeaderException extends FormatException {
  TarHeaderException(String message) : super(message);
}

/// Helper method to throw a [TarHeaderException].
void headerException([String message = '']) {
  throw TarHeaderException(message);
}

/// Helper method to throw a [TarFileException].
void fileException([String message = '']) {
  throw TarFileException(message);
}
