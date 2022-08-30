import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_service.dart';
import '../../models/pagination/pagination.dart';
import '../../models/product/product_filter.dart';
import '../state/product_state.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  final APIService _apiService;
  final ProductFilterModel _filterModel;
  int _page = 1;

  ProductsNotifier(this._apiService, this._filterModel)
      : super(const ProductsState());

  Future<void> getProducts() async {
    if (state.isLoading || !state.hasNext) {
      /* 
        isLoading -> already fetching, 
        !state.hasNext -> no records left
      */
      return;
    }

    // update state by copying object
    state = state.copyWith(isLoading: true);

    var filterModel = _filterModel.copyWith(
      paginationModel: PaginationModel(
        page: _page,
        pageSize: 10,
      ),
    );

    final products = await _apiService.getProducts(filterModel);
    final newProducts = [...state.products, ...products!];

    if (products.length % 10 != 0 || products.isEmpty) {
      // no more records
      state = state.copyWith(hasNext: false);
    }

    _page++;

    state = state.copyWith(products: newProducts);
    state = state.copyWith(isLoading: false);
  }

  Future<void> refreshProduct() async {
    state = state.copyWith(products: [], hasNext: true);

    _page = 1;

    await getProducts();
  }
}
