import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/components/product_card.dart';
import 'package:mobile/models/pagination/pagination.dart';
import 'package:mobile/models/product/product_filter.dart';
import 'package:mobile/providers/providers.dart';

import '../models/category/category.dart';
import '../models/product/product.dart';

class HomeProductsWidget extends ConsumerWidget {
  const HomeProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> list = List<Product>.empty(growable: true);

    return Container(
      color: const Color(0xffF4F7FA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 15),
                child: Text(
                  'Top 10 Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          _productsList(ref)
        ],
      ),
    );
  }

  Widget _productsList(WidgetRef ref) {
    final products = ref.watch(
      homeProductProvider(
        ProductFilterModel(
          paginationModel: PaginationModel(page: 1, pageSize: 10),
        ),
      ),
    );

    return products.when(
      data: (list) => _buildProductList(list!),
      error: (_, __) => const Center(child: Text("ERROR")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          var data = products[index];

          return GestureDetector(
            onTap: () {
              // TODO:
            },
            child: ProductCard(
              model: data,
            ),
          );
        },
      ),
    );
  }
}
