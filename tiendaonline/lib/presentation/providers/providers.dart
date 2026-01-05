import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendaonline/domain/repositories/catalog_repository.dart';
import 'package:tiendaonline/domain/usecases/metadata_usecases.dart';
import 'package:tiendaonline/domain/usecases/product_usecases.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiendaonline/data/repositories/auth_repository.dart';

// Repository
import 'package:tiendaonline/data/repositories/firestore_catalog_repository.dart';
import 'package:tiendaonline/data/services/storage_service.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return FirestoreCatalogRepository();
});

// UseCases - Metadata
final getCategoriesUseCaseProvider = Provider(
  (ref) => GetCategoriesUseCase(ref.watch(catalogRepositoryProvider)),
);
final getBrandsUseCaseProvider = Provider(
  (ref) => GetBrandsUseCase(ref.watch(catalogRepositoryProvider)),
);

// UseCases - Product Public
final getPublicProductsUseCaseProvider = Provider(
  (ref) => GetPublicProductsUseCase(ref.watch(catalogRepositoryProvider)),
);
final getProductBySlugUseCaseProvider = Provider(
  (ref) => GetProductBySlugUseCase(ref.watch(catalogRepositoryProvider)),
);

// UseCases - Product Admin
final getAdminProductsUseCaseProvider = Provider(
  (ref) => GetAdminProductsUseCase(ref.watch(catalogRepositoryProvider)),
);
final getAdminProductByIdUseCaseProvider = Provider(
  (ref) => GetAdminProductByIdUseCase(ref.watch(catalogRepositoryProvider)),
);

// UI Future Providers
final categoriesProvider = FutureProvider(
  (ref) => ref.watch(getCategoriesUseCaseProvider).call(),
);
final brandsProvider = FutureProvider(
  (ref) => ref.watch(getBrandsUseCaseProvider).call(),
);
final productsProvider = FutureProvider(
  (ref) => ref.watch(getPublicProductsUseCaseProvider).call(),
);

final productBySlugProvider = FutureProvider.family<Product?, String>((
  ref,
  slug,
) {
  return ref.watch(getProductBySlugUseCaseProvider).call(slug);
});

final adminProductsProvider = FutureProvider(
  (ref) => ref.watch(getAdminProductsUseCaseProvider).call(),
);

// Auth
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final storageServiceProvider = Provider((ref) => StorageService());
