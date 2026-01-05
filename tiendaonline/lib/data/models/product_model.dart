import 'package:json_annotation/json_annotation.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:tiendaonline/core/utils/json_converters.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  @JsonKey(name: 'id_producto')
  final String id;
  @JsonKey(name: 'estado')
  final String status;
  @JsonKey(name: 'titulo')
  final String title;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(name: 'descripcion_corta')
  final String shortDescription;
  @JsonKey(name: 'descripcion')
  final String description;
  @JsonKey(name: 'marca_id')
  final String brandId;
  @JsonKey(name: 'marca_nombre')
  final String brandName;
  @JsonKey(name: 'categorias_ids')
  final List<String> categoryIds;
  @JsonKey(name: 'imagenes')
  final List<ProductImageModel> imagesModel;
  @JsonKey(name: 'precio')
  final ProductPriceModel priceModel;
  @JsonKey(name: 'tiene_variantes')
  final bool hasVariants;
  @JsonKey(name: 'variantes')
  final List<ProductVariantModel> variantsModel;
  @JsonKey(name: 'ficha_tecnica')
  final Map<String, dynamic> technicalSpecs;
  @JsonKey(name: 'especificaciones_extra')
  final Map<String, dynamic> extraSpecs;
  @JsonKey(name: 'garantia')
  final ProductWarrantyModel warrantyModel;
  @JsonKey(name: 'envio')
  final ProductShippingModel shippingModel;
  @JsonKey(name: 'calificaciones')
  final ProductRatingModel ratingModel;
  @JsonKey(name: 'creado_en')
  @TimestampConverter()
  final DateTime createdAt;
  @JsonKey(name: 'actualizado_en')
  @TimestampConverter()
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.status,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.brandId,
    required this.brandName,
    required this.categoryIds,
    required this.imagesModel,
    required this.priceModel,
    required this.hasVariants,
    required this.variantsModel,
    required this.technicalSpecs,
    required this.extraSpecs,
    required this.warrantyModel,
    required this.shippingModel,
    required this.ratingModel,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         status: status,
         title: title,
         slug: slug,
         shortDescription: shortDescription,
         description: description,
         brandId: brandId,
         brandName: brandName,
         categoryIds: categoryIds,
         images: imagesModel,
         price: priceModel,
         hasVariants: hasVariants,
         variants: variantsModel,
         technicalSpecs: technicalSpecs,
         extraSpecs: extraSpecs,
         warranty: warrantyModel,
         shipping: shippingModel,
         rating: ratingModel,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class ProductImageModel extends ProductImage {
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'alt')
  final String alt;
  @JsonKey(name: 'orden')
  final int order;

  ProductImageModel({required this.url, required this.alt, required this.order})
    : super(url: url, alt: alt, order: order);

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
}

@JsonSerializable()
class ProductPriceModel extends ProductPrice {
  @JsonKey(name: 'moneda')
  final String currency;
  @JsonKey(name: 'base')
  final double base;
  @JsonKey(name: 'oferta')
  final double? offer;
  @JsonKey(name: 'oferta_inicio')
  @TimestampNullableConverter()
  final DateTime? offerStart;
  @JsonKey(name: 'oferta_fin')
  @TimestampNullableConverter()
  final DateTime? offerEnd;

  ProductPriceModel({
    required this.currency,
    required this.base,
    this.offer,
    this.offerStart,
    this.offerEnd,
  }) : super(
         currency: currency,
         base: base,
         offer: offer,
         offerStart: offerStart,
         offerEnd: offerEnd,
       );

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPriceModelFromJson(json);
}

@JsonSerializable()
class ProductVariantModel extends ProductVariant {
  @JsonKey(name: 'id_variante')
  final String id;
  @JsonKey(name: 'sku')
  final String sku;
  @JsonKey(name: 'titulo')
  final String title;
  @JsonKey(name: 'opciones')
  final Map<String, String> options;
  @JsonKey(name: 'precio_override')
  final double? priceOverride;
  @JsonKey(name: 'stock')
  final int stock;
  @JsonKey(name: 'imagen')
  final String? image;

  ProductVariantModel({
    required this.id,
    required this.sku,
    required this.title,
    required this.options,
    this.priceOverride,
    required this.stock,
    this.image,
  }) : super(
         id: id,
         sku: sku,
         title: title,
         options: options,
         priceOverride: priceOverride,
         stock: stock,
         image: image,
       );

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);
}

@JsonSerializable()
class ProductWarrantyModel extends ProductWarranty {
  @JsonKey(name: 'garantia_meses')
  final int months;
  @JsonKey(name: 'tipo')
  final String type;
  @JsonKey(name: 'condiciones')
  final String conditions;

  ProductWarrantyModel({
    required this.months,
    required this.type,
    required this.conditions,
  }) : super(months: months, type: type, conditions: conditions);

  factory ProductWarrantyModel.fromJson(Map<String, dynamic> json) =>
      _$ProductWarrantyModelFromJson(json);
}

@JsonSerializable()
class ProductShippingModel extends ProductShipping {
  @JsonKey(name: 'requiere_envio')
  final bool requiresShipping;
  @JsonKey(name: 'peso_gramos')
  final double weightGrams;
  @JsonKey(name: 'bateria_litio')
  final bool lithiumBattery;

  ProductShippingModel({
    required this.requiresShipping,
    required this.weightGrams,
    required this.lithiumBattery,
  }) : super(
         requiresShipping: requiresShipping,
         weightGrams: weightGrams,
         lithiumBattery: lithiumBattery,
       );

  factory ProductShippingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductShippingModelFromJson(json);
}

@JsonSerializable()
class ProductRatingModel extends ProductRating {
  @JsonKey(name: 'promedio')
  final double average;
  @JsonKey(name: 'cantidad')
  final int count;

  ProductRatingModel({required this.average, required this.count})
    : super(average: average, count: count);

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingModelFromJson(json);
}
