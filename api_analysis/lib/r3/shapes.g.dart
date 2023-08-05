// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shapes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionShape _$FunctionShapeFromJson(Map<String, dynamic> json) =>
    FunctionShape(
      name: json['name'] as String,
      positionalParameters: (json['positionalParameters'] as List<dynamic>)
          .map((e) =>
              PositionalParameterShape.fromJson(e as Map<String, dynamic>))
          .toList(),
      namedParameters: (json['namedParameters'] as List<dynamic>)
          .map((e) => NamedParameterShape.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FunctionShapeToJson(FunctionShape instance) =>
    <String, dynamic>{
      'name': instance.name,
      'positionalParameters': instance.positionalParameters,
      'namedParameters': instance.namedParameters,
    };

EnumShape _$EnumShapeFromJson(Map<String, dynamic> json) => EnumShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$EnumShapeToJson(EnumShape instance) => <String, dynamic>{
      'name': instance.name,
    };

ClassShape _$ClassShapeFromJson(Map<String, dynamic> json) => ClassShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ClassShapeToJson(ClassShape instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

MixinShape _$MixinShapeFromJson(Map<String, dynamic> json) => MixinShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$MixinShapeToJson(MixinShape instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

ExtensionShape _$ExtensionShapeFromJson(Map<String, dynamic> json) =>
    ExtensionShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ExtensionShapeToJson(ExtensionShape instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

FunctionTypeAliasShape _$FunctionTypeAliasShapeFromJson(
        Map<String, dynamic> json) =>
    FunctionTypeAliasShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$FunctionTypeAliasShapeToJson(
        FunctionTypeAliasShape instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

ClassTypeAliasShape _$ClassTypeAliasShapeFromJson(Map<String, dynamic> json) =>
    ClassTypeAliasShape(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ClassTypeAliasShapeToJson(
        ClassTypeAliasShape instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

VariableShape _$VariableShapeFromJson(Map<String, dynamic> json) =>
    VariableShape(
      name: json['name'] as String,
      hasGetter: json['hasGetter'] as bool,
      hasSetter: json['hasSetter'] as bool,
    );

Map<String, dynamic> _$VariableShapeToJson(VariableShape instance) =>
    <String, dynamic>{
      'name': instance.name,
      'hasGetter': instance.hasGetter,
      'hasSetter': instance.hasSetter,
    };

PositionalParameterShape _$PositionalParameterShapeFromJson(
        Map<String, dynamic> json) =>
    PositionalParameterShape(
      isOptional: json['isOptional'] as bool,
    );

Map<String, dynamic> _$PositionalParameterShapeToJson(
        PositionalParameterShape instance) =>
    <String, dynamic>{
      'isOptional': instance.isOptional,
    };

NamedParameterShape _$NamedParameterShapeFromJson(Map<String, dynamic> json) =>
    NamedParameterShape(
      name: json['name'] as String,
      isRequired: json['isRequired'] as bool,
    );

Map<String, dynamic> _$NamedParameterShapeToJson(
        NamedParameterShape instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isRequired': instance.isRequired,
    };
