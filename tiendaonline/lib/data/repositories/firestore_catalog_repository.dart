import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tiendaonline/data/models/brand_model.dart';
import 'package:tiendaonline/data/models/category_model.dart';
import 'package:tiendaonline/data/models/product_model.dart';
import 'package:tiendaonline/domain/entities/admin_product.dart';
import 'package:tiendaonline/domain/entities/brand.dart';
import 'package:tiendaonline/domain/entities/category.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:tiendaonline/domain/repositories/catalog_repository.dart';

class FirestoreCatalogRepository implements CatalogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');
  CollectionReference<Map<String, dynamic>> get _categoriesRef =>
      _firestore.collection('categories');
  CollectionReference<Map<String, dynamic>> get _brandsRef =>
      _firestore.collection('brands');

  @override
  Future<List<Product>> getProducts() async {
    await _checkAndSeed();
    final snapshot = await _productsRef
        .where('estado', isEqualTo: 'activo')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id_producto'] = doc.id;
      return ProductModel.fromJson(data);
    }).toList();
  }

  @override
  Future<Product?> getProductBySlug(String slug) async {
    final snapshot = await _productsRef
        .where('slug', isEqualTo: slug)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    data['id_producto'] = snapshot.docs.first.id;
    return ProductModel.fromJson(data);
  }

  @override
  Future<Product?> getProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    data['id_producto'] = doc.id;
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<Category>> getCategories() async {
    final snapshot = await _categoriesRef.orderBy('orden').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<Brand>> getBrands() async {
    final snapshot = await _brandsRef.get();
    return snapshot.docs.map((doc) => BrandModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<AdminProduct>> getAdminProducts() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs.map((doc) => _mapToAdminProduct(doc)).toList();
  }

  @override
  Future<AdminProduct?> getAdminProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    return _mapToAdminProduct(doc);
  }

  AdminProduct _mapToAdminProduct(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    // Helper to avoid nulls
    // Assume models handle JSON structure matching `tienda_electronica_seed.json`
    return AdminProduct(
      id: doc.id,
      status: data['estado'] ?? 'borrador',
      title: data['titulo'] ?? '',
      slug: data['slug'] ?? '',
      shortDescription: data['descripcion_corta'] ?? '',
      description: data['descripcion'] ?? '',
      brandId: data['marca_id'] ?? '',
      brandName: data['nombre_marca'] ?? 'Marca', // Should fetch or join
      categoryIds: List<String>.from(data['categorias_ids'] ?? []),
      images:
          (data['imagenes'] as List?)
              ?.map((i) => ProductImageModel.fromJson(i))
              .toList() ??
          [],
      price: ProductPriceModel.fromJson(data['precio'] ?? {}),
      hasVariants: data['tiene_variantes'] ?? false,
      variants:
          (data['variantes'] as List?)
              ?.map((v) => ProductVariantModel.fromJson(v))
              .toList() ??
          [],
      technicalSpecs: Map<String, dynamic>.from(data['ficha_tecnica'] ?? {}),
      extraSpecs: Map<String, dynamic>.from(data['specs_extra'] ?? {}),
      warranty: ProductWarrantyModel.fromJson(data['garantia'] ?? {}),
      shipping: ProductShippingModel.fromJson(data['envio'] ?? {}),
      rating: ProductRatingModel.fromJson(data['calificaciones'] ?? {}),
      createdAt: (data['creado_en'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (data['actualizado_en'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // Admin Fields
      cost: (data['costo'] as num?)?.toDouble() ?? 0.0,
      supplierId: data['proveedor_id'] ?? '',
      supplierName: data['proveedor'] ?? '',
      warehouseLocation: data['ubicacion_bodega'] ?? '',
      internalNotes: data['notas_internas'] ?? '',
      adminUpdatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveProduct(AdminProduct product) async {
    final data = {
      'estado': product.status,
      'titulo': product.title,
      'slug': product.slug.isNotEmpty
          ? product.slug
          : product.title.toLowerCase().replaceAll(' ', '-'),
      'descripcion': product.description,
      'marca_id': product.brandId,
      'categorias_ids': product.categoryIds,
      'precio': {
        'moneda': product.price.currency,
        'base': product.price.base,
        'oferta': product.price.offer,
        'oferta_inicio': product.price.offerStart,
        'oferta_fin': product.price.offerEnd,
      },
      'imagenes': product.images
          .map((i) => {'url': i.url, 'alt': i.alt, 'orden': i.order})
          .toList(),
      'costo': product.cost,
      // ... Add other fields properly aligned with JSON
      'actualizado_en': FieldValue.serverTimestamp(),
    };

    if (product.id.isEmpty) {
      data['creado_en'] = FieldValue.serverTimestamp();
      await _productsRef.add(data);
    } else {
      await _productsRef.doc(product.id).update(data);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  Future<void> _checkAndSeed() async {
    final docSnap = await _firestore
        .collection('config')
        .doc('seed_status')
        .get();
    if (docSnap.exists) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'tienda_electronica_seed.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final batch = _firestore.batch();

      final brands = jsonMap['marcas'] as List;
      for (var b in brands) {
        batch.set(
          _brandsRef.doc(b['datos']['id_marca']),
          _convertTimestamps(b['datos']),
        );
      }

      final cats = jsonMap['categorias'] as List;
      for (var c in cats) {
        batch.set(
          _categoriesRef.doc(c['datos']['id_categoria']),
          _convertTimestamps(c['datos']),
        );
      }

      final publicProds = jsonMap['productos_publicos'] as List;
      for (var p in publicProds) {
        final id = p['ruta'].split('/').last;
        batch.set(_productsRef.doc(id), _convertTimestamps(p['datos']));
      }

      await batch.commit();
      await _firestore.collection('config').doc('seed_status').set({
        'seeded_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Seeding Error: $e');
    }
  }

  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final Map<String, dynamic> result = {};
    data.forEach((key, value) {
      if (value is Map &&
          value.containsKey('__tipo__') &&
          value['__tipo__'] == 'timestamp') {
        result[key] = Timestamp.fromDate(DateTime.parse(value['valor']));
      } else if (value is Map<String, dynamic>) {
        result[key] = _convertTimestamps(value);
      } else if (value is List) {
        result[key] = value.map((e) {
          if (e is Map<String, dynamic>) return _convertTimestamps(e);
          return e;
        }).toList();
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}
