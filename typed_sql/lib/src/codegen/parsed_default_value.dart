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

/// @docImport '../typed_sql.dart';
library;

/// Parsed [DefaultValue] annotation.
sealed class ParsedDefaultValue {}

final class ParsedDefaultIntValue extends ParsedDefaultValue {
  final int value;

  ParsedDefaultIntValue(this.value);

  @override
  String toString() => '$value';
}

final class ParsedDefaultStringValue extends ParsedDefaultValue {
  final String value;

  ParsedDefaultStringValue(this.value);

  @override
  String toString() => "'${value.replaceAll("'", "\\'")}'";
}

final class ParsedDefaultBoolValue extends ParsedDefaultValue {
  final bool value;

  ParsedDefaultBoolValue(this.value);

  @override
  String toString() => '$value';
}

final class ParsedDefaultDoubleValue extends ParsedDefaultValue {
  final double value;

  ParsedDefaultDoubleValue(this.value);

  @override
  String toString() => '$value';
}

final class ParsedDefaultDateTimeValue extends ParsedDefaultValue {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;

  ParsedDefaultDateTimeValue(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.millisecond,
    this.microsecond,
  );

  @override
  String toString() {
    return 'DateTime($year, $month, $day, $hour, $minute, $second, $millisecond, $microsecond)';
  }
}

final class ParsedDefaultDateTimeEpochValue extends ParsedDefaultValue {
  @override
  String toString() => 'epoch';
}

final class ParsedDefaultDateTimeNow extends ParsedDefaultValue {
  @override
  String toString() => 'now';
}
