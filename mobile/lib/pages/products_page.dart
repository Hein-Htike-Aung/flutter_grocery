import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  static const routeName = 'products_page';

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

/* 
  categoryName ?? "Not found" (categoryName or Not found)
*/

class _ProductsPageState extends State<ProductsPage> {
  String? categoryId;
  String? categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Text(categoryName ?? "No found"),
    );
  }

  // Receiving passed arguments
  @override
  void didChangeDependencies() {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    categoryName = arguments['categoryName'];
    categoryId = arguments['categoryId'];

    super.didChangeDependencies();
  }
}
