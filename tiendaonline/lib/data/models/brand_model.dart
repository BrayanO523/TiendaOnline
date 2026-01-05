import 'package:json_annotation/json_annotation.dart';
import 'package:tiendaonline/domain/entities/brand.dart';
import 'package:tiendaonline/core/utils/json_converters.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel extends Brand {
  @JsonKey(name: 'id_marca')
  final String id;
  @JsonKey(name: 'nombre')
  final String name;
  @JsonKey(name: 'activo')
  final Boolean active;
  @JsonKey(name: 'creado_en')
  @TimestampConverter()
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.name,
    required this.active,
    required this.createdAt,
  }) : super(id: id, name: name, active: active, createdAt: createdAt);

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}

// Hotfix for Boolean vs bool typoz
typedef Boolean = bool;
