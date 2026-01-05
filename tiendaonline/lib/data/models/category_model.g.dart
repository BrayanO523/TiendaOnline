// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id_categoria'] as String,
      name: json['nombre'] as String,
      slug: json['slug'] as String,
      parentId: json['id_padre'] as String?,
      order: (json['orden'] as num).toInt(),
      active: json['activa'] as bool,
      createdAt: const TimestampConverter().fromJson(
        json['creado_en'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id_categoria': instance.id,
      'nombre': instance.name,
      'slug': instance.slug,
      'id_padre': instance.parentId,
      'orden': instance.order,
      'activa': instance.active,
      'creado_en': const TimestampConverter().toJson(instance.createdAt),
    };
