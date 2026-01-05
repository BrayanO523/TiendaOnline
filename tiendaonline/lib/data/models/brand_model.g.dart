// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
  id: json['id_marca'] as String,
  name: json['nombre'] as String,
  active: json['activo'] as bool,
  createdAt: const TimestampConverter().fromJson(
    json['creado_en'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'id_marca': instance.id,
      'nombre': instance.name,
      'activo': instance.active,
      'creado_en': const TimestampConverter().toJson(instance.createdAt),
    };
