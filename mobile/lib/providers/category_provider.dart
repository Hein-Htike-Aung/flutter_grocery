
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_service.dart';
import '../models/category/category.dart';
import '../models/pagination/pagination.dart';


final categoriesProvider = FutureProvider.family<List<Category>?, PaginationModel>(
  (ref, paginationModel) {
    final apiRepository = ref.watch(apiService); // dependency injection

    return apiRepository.getCategories(
      paginationModel.page,
      paginationModel.pageSize,
    );
  },
);
