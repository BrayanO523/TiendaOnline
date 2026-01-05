// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id_producto'] as String,
  status: json['estado'] as String,
  title: json['titulo'] as String,
  slug: json['slug'] as String,
  shortDescription: json['descripcion_corta'] as String,
  description: json['descripcion'] as String,
  brandId: json['marca_id'] as String,
  brandName: json['marca_nombre'] as String,
  categoryIds: (json['categorias_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  imagesModel: (json['imagenes'] as List<dynamic>)
      .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  priceModel: ProductPriceModel.fromJson(
    json['precio'] as Map<String, dynamic>,
  ),
  hasVariants: json['tiene_variantes'] as bool,
  variantsModel: (json['variantes'] as List<dynamic>)
      .map((e) => ProductVariantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  technicalSpecs: json['ficha_tecnica'] as Map<String, dynamic>,
  extraSpecs: json['especificaciones_extra'] as Map<String, dynamic>,
  warrantyModel: ProductWarrantyModel.fromJson(
    json['garantia'] as Map<String, dynamic>,
  ),
  shippingModel: ProductShippingModel.fromJson(
    json['envio'] as Map<String, dynamic>,
  ),
  ratingModel: ProductRatingModel.fromJson(
    json['calificaciones'] as Map<String, dynamic>,
  ),
  createdAt: const TimestampConverter().fromJson(
    json['creado_en'] as Map<String, dynamic>,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['actualizado_en'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id_producto': instance.id,
      'estado': instance.status,
      'titulo': instance.title,
      'slug': instance.slug,
      'descripcion_corta': instance.shortDescription,
      'descripcion': instance.description,
      'marca_id': instance.brandId,
      'marca_nombre': instance.brandName,
      'categorias_ids': instance.categoryIds,
      'imagenes': instance.imagesModel,
      'precio': instance.priceModel,
      'tiene_variantes': instance.hasVariants,
      'variantes': instance.variantsModel,
      'ficha_tecnica': instance.technicalSpecs,
      'especificaciones_extra': instance.extraSpecs,
      'garantia': instance.warrantyModel,
      'envio': instance.shippingModel,
      'calificaciones': instance.ratingModel,
      'creado_en': const TimestampConverter().toJson(instance.createdAt),
      'actualizado_en': const TimestampConverter().toJson(instance.updatedAt),
    };

ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    ProductImageModel(
      url: json['url'] as String,
      alt: json['alt'] as String,
      order: (json['orden'] as num).toInt(),
    );

Map<String, dynamic> _$ProductImageModelToJson(ProductImageModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'alt': instance.alt,
      'orden': instance.order,
    };

ProductPriceModel _$ProductPriceModelFromJson(Map<String, dynamic> json) =>
    ProductPriceModel(
      currency: json['moneda'] as String,
      base: (json['base'] as num).toDouble(),
      offer: (json['oferta'] as num?)?.toDouble(),
      offerStart: const TimestampNullableConverter().fromJson(
        json['oferta_inicio'] as Map<String, dynamic>?,
      ),
      offerEnd: const TimestampNullableConverter().fromJson(
        json['oferta_fin'] as Map<String, dynamic>?,
      ),
    );

Map<String, dynamic> _$ProductPriceModelToJson(
  ProductPriceModel instance,
) => <String, dynamic>{
  'moneda': instance.currency,
  'base': instance.base,
  'oferta': instance.offer,
  'oferta_inicio': const TimestampNullableConverter().toJson(
    instance.offerStart,
  ),
  'oferta_fin': const TimestampNullableConverter().toJson(instance.offerEnd),
};

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    ProductVariantModel(
      id: json['id_variante'] as String,
      sku: json['sku'] as String,
      title: json['titulo'] as String,
      options: Map<String, String>.from(json['opciones'] as Map),
      priceOverride: (json['precio_override'] as num?)?.toDouble(),
      stock: (json['stock'] as num).toInt(),
      image: json['imagen'] as String?,
    );

Map<String, dynamic> _$ProductVariantModelToJson(
  ProductVariantModel instance,
) => <String, dynamic>{
  'id_variante': instance.id,
  'sku': instance.sku,
  'titulo': instance.title,
  'opciones': instance.options,
  'precio_override': instance.priceOverride,
  'stock': instance.stock,
  'imagen': instance.image,
};

ProductWarrantyModel _$ProductWarrantyModelFromJson(
  Map<String, dynamic> json,
) => ProductWarrantyModel(
  months: (json['garantia_meses'] as num).toInt(),
  type: json['tipo'] as String,
  conditions: json['condiciones'] as String,
);

Map<String, dynamic> _$ProductWarrantyModelToJson(
  ProductWarrantyModel instance,
) => <String, dynamic>{
  'garantia_meses': instance.months,
  'tipo': instance.type,
  'condiciones': instance.conditions,
};

ProductShippingModel _$ProductShippingModelFromJson(
  Map<String, dynamic> json,
) => ProductShippingModel(
  requiresShipping: json['requiere_envio'] as bool,
  weightGrams: (json['peso_gramos'] as num).toDouble(),
  lithiumBattery: json['bateria_litio'] as bool,
);

Map<String, dynamic> _$ProductShippingModelToJson(
  ProductShippingModel instance,
) => <String, dynamic>{
  'requiere_envio': instance.requiresShipping,
  'peso_gramos': instance.weightGrams,
  'bateria_litio': instance.lithiumBattery,
};

ProductRatingModel _$ProductRatingModelFromJson(Map<String, dynamic> json) =>
    ProductRatingModel(
      average: (json['promedio'] as num).toDouble(),
      count: (json['cantidad'] as num).toInt(),
    );

Map<String, dynamic> _$ProductRatingModelToJson(ProductRatingModel instance) =>
    <String, dynamic>{'promedio': instance.average, 'cantidad': instance.count};
