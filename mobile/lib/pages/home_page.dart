import 'package:flutter/material.dart';
import 'package:mobile/components/product_card.dart';
import 'package:mobile/widgets/widget_home_products.dart';

import '../models/category/category.dart';
import '../models/product/product.dart';
import '../widgets/widget_home_categories.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            const HomeCategoriesWidget(),
            // ProductCard(model: model),
            const HomeProductsWidget()
          ],
        ),
      ),
    );
  }
}
