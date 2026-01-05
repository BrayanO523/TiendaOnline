import 'package:tiendaonline/domain/entities/admin_product.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:tiendaonline/domain/repositories/catalog_repository.dart';

class GetPublicProductsUseCase {
  final CatalogRepository repository;
  GetPublicProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}

class GetProductBySlugUseCase {
  final CatalogRepository repository;
  GetProductBySlugUseCase(this.repository);

  Future<Product?> call(String slug) {
    return repository.getProductBySlug(slug);
  }
}

class GetAdminProductsUseCase {
  final CatalogRepository repository;
  GetAdminProductsUseCase(this.repository);

  Future<List<AdminProduct>> call() {
    return repository.getAdminProducts();
  }
}

class GetAdminProductByIdUseCase {
  final CatalogRepository repository;
  GetAdminProductByIdUseCase(this.repository);

  Future<AdminProduct?> call(String id) {
    return repository.getAdminProductById(id);
  }
}
