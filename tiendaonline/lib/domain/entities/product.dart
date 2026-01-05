class Product {
  final String id;
  final String status;
  final String title;
  final String slug;
  final String shortDescription;
  final String description;
  final String brandId;
  final String brandName;
  final List<String> categoryIds;
  final List<ProductImage> images;
  final ProductPrice price;
  final bool hasVariants;
  final List<ProductVariant> variants;
  final Map<String, dynamic> technicalSpecs;
  final Map<String, dynamic> extraSpecs;
  final ProductWarranty warranty;
  final ProductShipping shipping;
  final ProductRating rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.status,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.brandId,
    required this.brandName,
    required this.categoryIds,
    required this.images,
    required this.price,
    required this.hasVariants,
    required this.variants,
    required this.technicalSpecs,
    required this.extraSpecs,
    required this.warranty,
    required this.shipping,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper to get main image
  String get mainImage => images.isNotEmpty ? images.first.url : '';
}

class ProductImage {
  final String url;
  final String alt;
  final int order;

  ProductImage({required this.url, required this.alt, required this.order});
}

class ProductPrice {
  final String currency;
  final double base;
  final double? offer;
  final DateTime? offerStart;
  final DateTime? offerEnd;

  ProductPrice({
    required this.currency,
    required this.base,
    this.offer,
    this.offerStart,
    this.offerEnd,
  });

  bool get isOfferActive {
    if (offer == null) return false;
    final now = DateTime.now();
    if (offerStart != null && now.isBefore(offerStart!)) return false;
    if (offerEnd != null && now.isAfter(offerEnd!)) return false;
    return true;
  }

  double get currentPrice => isOfferActive ? offer! : base;
}

class ProductVariant {
  final String id;
  final String sku;
  final String title;
  final Map<String, String> options;
  final double? priceOverride;
  final int stock;
  final String? image;

  ProductVariant({
    required this.id,
    required this.sku,
    required this.title,
    required this.options,
    this.priceOverride,
    required this.stock,
    this.image,
  });
}

class ProductWarranty {
  final int months;
  final String type;
  final String conditions;

  ProductWarranty({
    required this.months,
    required this.type,
    required this.conditions,
  });
}

class ProductShipping {
  final bool requiresShipping;
  final double weightGrams;
  final bool lithiumBattery;
  // Dimensions ignored for simplified entity, can add if needed

  ProductShipping({
    required this.requiresShipping,
    required this.weightGrams,
    required this.lithiumBattery,
  });
}

class ProductRating {
  final double average;
  final int count;

  ProductRating({required this.average, required this.count});
}
