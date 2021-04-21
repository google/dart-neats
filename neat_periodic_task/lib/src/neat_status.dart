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

import 'dart:convert' show utf8, json;
import 'package:json_annotation/json_annotation.dart';

part 'neat_status.g.dart';

/// Status of a NeatPeriodicTask.
@JsonSerializable()
class NeatTaskStatus {
  /// Value of the 'format' property.
  ///
  /// This value is used to ensure that we're not reading a JSON object that
  /// isn't a status.
  static const formatIdentifier = 'neat-periodic-task-status';

  /// Latest version of the NeatTaskStatus file.
  static const currentVersion = 1;

  /// Magic value that identifies the format, this must always match
  /// [formatIdentifier] or the status object is ignored.
  final String format;

  /// Version of the status object.
  ///
  /// If this value is less than [currentVersion] then the object is ignored.
  /// If this value is greater than [currentVersion] a warning is printed and
  /// no further action is taken.
  final int version;

  /// Current state, one of 'finished', 'running'.
  final String state;

  /// Time the task started running.
  final DateTime started;

  /// Owner if this status object, only relevant if [state] is 'running'.
  ///
  /// The [owner] is a random slugid that identifies the process that owns the
  /// exclusive right to run the periodic task.
  final String owner;

  NeatTaskStatus({
    required this.format,
    required this.version,
    required this.state,
    required this.started,
    required this.owner,
  });

  NeatTaskStatus.create({
    required this.state,
    required this.started,
    required this.owner,
  })  : format = formatIdentifier,
        version = currentVersion;

  /// Create a new [NeatTaskStatus] updating the given values.
  NeatTaskStatus update({
    String? state,
    DateTime? started,
    String? owner,
  }) {
    return NeatTaskStatus(
      format: formatIdentifier,
      version: currentVersion,
      state: state ?? this.state,
      started: started ?? this.started,
      owner: owner ?? this.owner,
    );
  }

  static NeatTaskStatus _initial() => NeatTaskStatus(
        format: formatIdentifier,
        version: currentVersion,
        state: 'idle',
        started: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        owner: '-',
      );

  factory NeatTaskStatus.deserialize(List<int>? bytes) {
    if (bytes == null) {
      return _initial();
    }

    NeatTaskStatus val;
    try {
      final raw = json.fuse(utf8).decode(bytes);
      if (raw == null) {
        return _initial();
      }
      val = _$NeatTaskStatusFromJson(
        raw as Map<String, dynamic>,
      );
      if (val.format != formatIdentifier || val.version < currentVersion) {
        return _initial();
      }
      return val;
    } catch (_) {
      return _initial();
    }
  }

  List<int> serialize() => json.fuse(utf8).encode(_$NeatTaskStatusToJson(this));
}
