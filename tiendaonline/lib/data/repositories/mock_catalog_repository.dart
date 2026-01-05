import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tiendaonline/data/models/brand_model.dart';
import 'package:tiendaonline/data/models/category_model.dart';
import 'package:tiendaonline/data/models/product_model.dart';
import 'package:tiendaonline/domain/entities/admin_product.dart';
import 'package:tiendaonline/domain/entities/brand.dart';
import 'package:tiendaonline/domain/entities/category.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:tiendaonline/domain/repositories/catalog_repository.dart';

class MockCatalogRepository implements CatalogRepository {
  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  List<ProductModel> _products = [];
  Map<String, Map<String, dynamic>> _adminData = {};

  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString(
        'tienda_electronica_seed.json',
      );
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> docs = data['docs'] as List<dynamic>;

      for (var doc in docs) {
        final String ruta = doc['ruta'] as String;
        final Map<String, dynamic> datos = doc['datos'] as Map<String, dynamic>;

        if (ruta.startsWith('marcas/')) {
          _brands.add(BrandModel.fromJson(datos));
        } else if (ruta.startsWith('categorias/')) {
          _categories.add(CategoryModel.fromJson(datos));
        } else if (ruta.startsWith('productos_publicos/')) {
          _products.add(ProductModel.fromJson(datos));
        } else if (ruta.startsWith('productos_admin/')) {
          // Store admin data keyed by product ID
          final id = datos['id_producto'];
          _adminData[id] = datos;
        }
      }

      _isLoaded = true;
    } catch (e) {
      print('Error loading seed data: $e');
      // Should probably rethrow or handle gracefully
    }
  }

  @override
  Future<List<Brand>> getBrands() async {
    await _ensureLoaded();
    return _brands;
  }

  @override
  Future<List<Category>> getCategories() async {
    await _ensureLoaded();
    // Sort by order
    _categories.sort((a, b) => a.order.compareTo(b.order));
    return _categories;
  }

  @override
  Future<List<Product>> getProducts() async {
    await _ensureLoaded();
    return _products;
  }

  @override
  Future<Product?> getProductBySlug(String slug) async {
    await _ensureLoaded();
    try {
      return _products.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    await _ensureLoaded();
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AdminProduct>> getAdminProducts() async {
    await _ensureLoaded();
    final List<AdminProduct> adminProducts = [];

    for (var product in _products) {
      final adminInfo = _adminData[product.id];
      if (adminInfo != null) {
        adminProducts.add(_mergeToAdminProduct(product, adminInfo));
      } else {
        // Should not happen in consistent seed, but handle gracefully?
        // Skip or create with defaults. Skipping for now.
      }
    }
    return adminProducts;
  }

  @override
  Future<AdminProduct?> getAdminProductById(String id) async {
    await _ensureLoaded();
    final product = await getProductById(id);
    if (product == null) return null;

    final adminInfo = _adminData[product.id];
    if (adminInfo == null) return null;

    return _mergeToAdminProduct(product as ProductModel, adminInfo);
  }

  AdminProduct _mergeToAdminProduct(
    ProductModel p,
    Map<String, dynamic> adminInfo,
  ) {
    // Extract admin fields
    // "cost": 8568.93,
    // "proveedor": { ... },
    // "ubicacion_bodega": "...",
    // "notas_internas": "...",
    // "actualizado_en": { ... }

    final supplierData = adminInfo['proveedor'] as Map<String, dynamic>;
    final adminUpdatedRaw = adminInfo['actualizado_en'];
    // We need to parse Timestamp manualy here effectively, or duplicate logic
    DateTime adminUpdated;
    if (adminUpdatedRaw != null && adminUpdatedRaw['__tipo__'] == 'timestamp') {
      adminUpdated = DateTime.parse(adminUpdatedRaw['valor']);
    } else {
      adminUpdated = DateTime.now(); // Fallback
    }

    return AdminProduct(
      id: p.id,
      status: p.status,
      title: p.title,
      slug: p.slug,
      shortDescription: p.shortDescription,
      description: p.description,
      brandId: p.brandId,
      brandName: p.brandName,
      categoryIds: p.categoryIds,
      images: p.images,
      price: p.price,
      hasVariants: p.hasVariants,
      variants: p.variants,
      technicalSpecs: p.technicalSpecs,
      extraSpecs: p.extraSpecs,
      warranty: p.warranty,
      shipping: p.shipping,
      rating: p.rating,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
      // Admin specific
      cost: (adminInfo['costo'] as num).toDouble(),
      supplierId: supplierData['id_proveedor'],
      supplierName: supplierData['nombre'],
      warehouseLocation: adminInfo['ubicacion_bodega'],
      internalNotes: adminInfo['notas_internas'],
      adminUpdatedAt: adminUpdated,
    );
  }

  @override
  Future<void> saveProduct(AdminProduct product) async {}

  @override
  Future<void> deleteProduct(String id) async {}
}
