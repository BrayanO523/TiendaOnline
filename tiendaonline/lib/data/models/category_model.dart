import 'package:json_annotation/json_annotation.dart';
import 'package:tiendaonline/domain/entities/category.dart';
import 'package:tiendaonline/core/utils/json_converters.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Category {
  @JsonKey(name: 'id_categoria')
  final String id;
  @JsonKey(name: 'nombre')
  final String name;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(name: 'id_padre')
  final String? parentId;
  @JsonKey(name: 'orden')
  final int order;
  @JsonKey(name: 'activa')
  final bool active;
  @JsonKey(name: 'creado_en')
  @TimestampConverter()
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    required this.order,
    required this.active,
    required this.createdAt,
  }) : super(
         id: id,
         name: name,
         slug: slug,
         parentId: parentId,
         order: order,
         active: active,
         createdAt: createdAt,
       );

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
