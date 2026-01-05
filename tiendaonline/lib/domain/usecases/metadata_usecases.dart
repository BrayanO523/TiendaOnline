import 'package:tiendaonline/domain/entities/brand.dart';
import 'package:tiendaonline/domain/entities/category.dart';
import 'package:tiendaonline/domain/repositories/catalog_repository.dart';

class GetCategoriesUseCase {
  final CatalogRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}

class GetBrandsUseCase {
  final CatalogRepository repository;
  GetBrandsUseCase(this.repository);

  Future<List<Brand>> call() {
    return repository.getBrands();
  }
}
