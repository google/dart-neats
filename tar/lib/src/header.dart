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

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'constants.dart';
import 'format.dart';

/// A [TarHeader] represents a single header in a tar archive.
///
/// This class contains all the possible fields for all the different
/// [TarFormat]s. Since different TAR formats contain different fields, not all
/// the fields may be populated.
@sealed
abstract class TarHeader {
  /// Type of header entry. In the V7 TAR format, this field was known as the
  /// link flag.
  TypeFlag get typeFlag;

  /// Name of file or directory entry.
  String get name;

  /// Target name of link (valid for hard links or symbolic links).
  String get linkName;

  /// Permission and mode bits.
  int get mode;

  /// User ID of owner.
  int get userId;

  /// Group ID of owner.
  int get groupId;

  /// User name of owner.
  String get userName;

  /// Group name of owner.
  String get groupName;

  /// Logical file size in bytes.
  int get size;

  /// The time of the last change to the data of the TAR file.
  DateTime get modified;

  /// The time of the last access to the data of the TAR file.
  DateTime get accessed;

  /// The time of the last change to the data or metadata of the TAR file.
  DateTime get changed;

  /// Major device number
  int get devMajor;

  /// Minor device number
  int get devMinor;

  /// Map of PAX extended records.
  Map<String, String> get paxRecords;

  /// The TAR format of the header.
  TarFormat get format;

  /// Checks if this header indicates that the file will have content.
  bool get hasContent {
    switch (typeFlag) {
      case TypeFlag.link:
      case TypeFlag.symlink:
      case TypeFlag.block:
      case TypeFlag.dir:
      case TypeFlag.char:
      case TypeFlag.fifo:
        return false;
      default:
        return true;
    }
  }

  @override
  bool operator ==(other) {
    if (other is! TarHeader) return false;
    final otherHeader = other as TarHeader;

    return name == otherHeader.name &&
        modified == otherHeader.modified &&
        linkName == otherHeader.linkName &&
        mode == otherHeader.mode &&
        size == otherHeader.size &&
        userName == otherHeader.userName &&
        userId == otherHeader.userId &&
        groupId == otherHeader.groupId &&
        groupName == otherHeader.groupName &&
        accessed == otherHeader.accessed &&
        changed == otherHeader.changed &&
        devMajor == otherHeader.devMajor &&
        devMinor == otherHeader.devMinor &&
        MapEquality().equals(paxRecords, otherHeader.paxRecords) &&
        format == otherHeader.format &&
        typeFlag == otherHeader.typeFlag;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        (modified.hashCode ?? 0) ^
        linkName.hashCode ^
        mode ^
        size ^
        userName.hashCode ^
        userId ^
        groupId ^
        groupName.hashCode ^
        (accessed.hashCode ?? 0) ^
        (changed.hashCode ?? 0) ^
        devMajor ^
        devMinor ^
        MapEquality().hash(paxRecords) ^
        (format.hashCode ?? 0) ^
        typeFlag.hashCode;
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'lastModifiedTime: $modified\n'
        'linkName: $linkName\n'
        'Mode: $mode\n'
        'Size: $size\n'
        'Username: $userName\n'
        'UserId: $userId\n'
        'GroupId: $groupId\n'
        'GroupName: $groupName\n'
        'AccessTime: $accessed\n'
        'ChangeTime: $changed\n'
        'DevMajor: $devMajor\n'
        'DevMinor: $devMinor\n'
        'PAXRecords: $paxRecords\n'
        'Format: $format\n'
        'LinkFlag: $typeFlag\n';
  }
}
