import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/models/pagination/pagination.dart';
import 'package:mobile/models/product/product_filter.dart';

class ProductsFilterNotifier extends StateNotifier<ProductFilterModel> {
  
  ProductsFilterNotifier()
      : super(
          ProductFilterModel(
            paginationModel: PaginationModel(page: 0, pageSize: 10),
          ),
        );

  void seteProductFilter(ProductFilterModel model) {
    state = model;
  }
}
