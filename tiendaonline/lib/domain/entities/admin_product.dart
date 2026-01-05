import 'package:tiendaonline/domain/entities/product.dart';

class AdminProduct extends Product {
  final double cost;
  final String supplierId;
  final String supplierName;
  final String warehouseLocation;
  final String internalNotes;
  final DateTime adminUpdatedAt;

  AdminProduct({
    required super.id,
    required super.status,
    required super.title,
    required super.slug,
    required super.shortDescription,
    required super.description,
    required super.brandId,
    required super.brandName,
    required super.categoryIds,
    required super.images,
    required super.price,
    required super.hasVariants,
    required super.variants,
    required super.technicalSpecs,
    required super.extraSpecs,
    required super.warranty,
    required super.shipping,
    required super.rating,
    required super.createdAt,
    required super.updatedAt,
    required this.cost,
    required this.supplierId,
    required this.supplierName,
    required this.warehouseLocation,
    required this.internalNotes,
    required this.adminUpdatedAt,
  });
}
