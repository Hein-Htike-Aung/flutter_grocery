import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/application/notifier/product_filter_notifier.dart';
import 'package:mobile/application/notifier/products_notifier.dart';
import 'package:mobile/application/state/product_state.dart';

import '../api/api_service.dart';
import '../models/category/category.dart';
import '../models/pagination/pagination.dart';
import '../models/product/product.dart';
import '../models/product/product_filter.dart';

final categoriesProvider =
    FutureProvider.family<List<Category>?, PaginationModel>(
  (ref, paginationModel) {
    final apiRepository = ref.watch(apiService); // dependency injection

    return apiRepository.getCategories(
      paginationModel.page,
      paginationModel.pageSize,
    );
  },
);

final homeProductProvider =
    FutureProvider.family<List<Product>?, ProductFilterModel>(
        (ref, productFilterModel) {
  final apiRepository = ref.watch(apiService);

  return apiRepository.getProducts(productFilterModel);
});

final productsFilterProvider =
    StateNotifierProvider<ProductsFilterNotifier, ProductFilterModel>(
  (ref) => ProductsFilterNotifier(),
);

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(
    ref.watch(apiService),
    ref.watch(productsFilterProvider),
  ),
);
