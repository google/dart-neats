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

enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3);

  const LogLevel(this.value);

  final int value;

  bool operator >(LogLevel other) => index > other.index;
}

typedef LogFunction = void Function(String message, LogLevel level);

final class Logger {
  final LogFunction _log;
  Logger(this._log);

  void info(String message) => _log(message, LogLevel.info);
  void debug(String message) => _log(message, LogLevel.debug);
  void warning(String message) => _log(message, LogLevel.warning);
  void error(String message) => _log(message, LogLevel.error);
  void log(String message, LogLevel level) => _log(message, level);
}
