// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neat_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeatTaskStatus _$NeatTaskStatusFromJson(Map<String, dynamic> json) {
  return NeatTaskStatus(
    format: json['format'] as String,
    version: json['version'] as int,
    state: json['state'] as String,
    started: DateTime.parse(json['started'] as String),
    owner: json['owner'] as String,
  );
}

Map<String, dynamic> _$NeatTaskStatusToJson(NeatTaskStatus instance) =>
    <String, dynamic>{
      'format': instance.format,
      'version': instance.version,
      'state': instance.state,
      'started': instance.started.toIso8601String(),
      'owner': instance.owner,
    };
