import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category/category.dart';
import '../models/pagination/pagination.dart';
import '../pages/products_page.dart';
import '../providers/category_provider.dart';


class HomeCategoriesWidget extends ConsumerWidget {
  const HomeCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "All Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _categoriesList(ref)
        ],
      ),
    );
  }

  // ref can consume as many as provider that created
  Widget _categoriesList(WidgetRef ref) {
    final categories = ref.watch(
      categoriesProvider(
        PaginationModel(page: 1, pageSize: 10),
      ),
    );

    return categories.when(
      data: (list) => _buildCategoryList(list!),
      error: (_, __) => const Center(child: Text("ERROR")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return Container(
      height: 100,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true, // Scrolling
        physics: const ClampingScrollPhysics(), // Scrolling
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: ((context, index) {
          var data = categories[index];
          return GestureDetector(
            onTap: () {
              /// Navigate & Passing data
              Navigator.of(context).pushNamed(
                ProductsPage.routeName,
                arguments: {
                  'categoryId': data.categoryId,
                  'categoryName': data.categoryName
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: Image.network(
                      data.fullImagePath,
                      height: 50,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data.categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 13,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
