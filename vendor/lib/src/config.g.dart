// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorState _$VendorStateFromJson(Map json) => $checkedCreate(
      '_VendorState',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['version', 'config'],
          requiredKeys: const ['version', 'config'],
        );
        final val = _VendorState(
          $checkedConvert('version', (v) => _versionFromJson(v as Object)),
          $checkedConvert('config', (v) => _VendorConfig.fromJson(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$VendorStateToJson(_VendorState instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', _versionToJson(instance.version));
  val['config'] = instance.config;
  return val;
}

_VendorConfig _$VendorConfigFromJson(Map json) => $checkedCreate(
      '_VendorConfig',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['import_rewrites', 'vendored_dependencies'],
        );
        final val = _VendorConfig(
          $checkedConvert(
              'import_rewrites',
              (v) =>
                  (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e as String),
                  ) ??
                  {}),
          $checkedConvert(
              'vendored_dependencies',
              (v) =>
                  (v as Map?)?.map(
                    (k, e) => MapEntry(
                        k as String, _VendoredSource.fromJson(e as Map)),
                  ) ??
                  {}),
        );
        return val;
      },
      fieldKeyMap: const {
        'rewrites': 'import_rewrites',
        'dependencies': 'vendored_dependencies'
      },
    );

Map<String, dynamic> _$VendorConfigToJson(_VendorConfig instance) {
  final val = <String, dynamic>{
    'import_rewrites': instance.rewrites,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'vendored_dependencies', _dependenciesToJson(instance.dependencies));
  return val;
}

_VendoredSource _$VendoredSourceFromJson(Map json) => $checkedCreate(
      '_VendoredSource',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'package',
            'version',
            'import_rewrites',
            'include'
          ],
          requiredKeys: const ['package', 'version'],
        );
        final val = _VendoredSource(
          package: $checkedConvert('package', (v) => v as String),
          version:
              $checkedConvert('version', (v) => _versionFromJson(v as Object)),
          rewrites: $checkedConvert(
              'import_rewrites',
              (v) =>
                  (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e as String),
                  ) ??
                  {}),
          include: $checkedConvert(
              'include',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toSet() ??
                  {
                    'pubspec.yaml',
                    'README.md',
                    'LICENSE',
                    'CHANGELOG.md',
                    'lib/**',
                    'analysis_options.yaml'
                  }),
        );
        return val;
      },
      fieldKeyMap: const {'rewrites': 'import_rewrites'},
    );

Map<String, dynamic> _$VendoredSourceToJson(_VendoredSource instance) {
  final val = <String, dynamic>{
    'package': instance.package,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', _versionToJson(instance.version));
  val['import_rewrites'] = instance.rewrites;
  val['include'] = instance.include.toList();
  return val;
}
