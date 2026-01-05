import 'package:tiendaonline/domain/entities/admin_product.dart';
import 'package:tiendaonline/domain/entities/brand.dart';
import 'package:tiendaonline/domain/entities/category.dart';
import 'package:tiendaonline/domain/entities/product.dart';

abstract class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<List<Brand>> getBrands();
  Future<List<Product>> getProducts();
  Future<Product?> getProductBySlug(String slug);
  Future<Product?> getProductById(String id);

  // Admin methods
  Future<List<AdminProduct>> getAdminProducts();
  Future<AdminProduct?> getAdminProductById(String id);
  Future<void> saveProduct(AdminProduct product);
  Future<void> deleteProduct(String id);
}
