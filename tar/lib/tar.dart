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

/// Tape Archives (TAR) are a file format for storing a sequence of files that
/// can be read and written in a streaming manner. This package aims to cover
/// most variations of the format, including those produced by GNU and BSD tar
/// tools.
library tar;

export 'src/constants.dart' show TypeFlag;
export 'src/exceptions.dart' show TarFileException, TarHeaderException;
export 'src/header.dart';
export 'src/reader.dart';
