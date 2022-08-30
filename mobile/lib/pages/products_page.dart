import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/application/state/product_state.dart';
import 'package:mobile/components/product_card.dart';
import 'package:mobile/models/pagination/pagination.dart';
import 'package:mobile/models/product/product_filter.dart';
import 'package:mobile/models/product/product_sort.dart';
import 'package:mobile/providers/providers.dart';

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
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductFilters(
              categoryId: categoryId,
              categoryName: categoryName,
            ),
            Flexible(
              flex: 1,
              child: _ProductList(),
            )
          ],
        ),
      ),
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

class _ProductFilters extends ConsumerWidget {
  final _sortByOptions = [
    ProductSortModel(value: 'createdAt', label: 'Latest'),
    ProductSortModel(value: '-productPrice', label: 'Price: High to Low'),
    ProductSortModel(value: 'productPrice', label: 'Price: Low to High'),
  ];

  final String? categoryName;
  final String? categoryId;

  _ProductFilters({
    Key? key,
    this.categoryName,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch(productsFilterProvider);

    return Container(
      height: 51,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          // Filter Icon
          Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: PopupMenuButton(
              initialValue: filterProvider.sortBy,
              onSelected: (sortBy) {
                ProductFilterModel filterModel = ProductFilterModel(
                  paginationModel: PaginationModel(page: 0, pageSize: 10),
                  categoryId: filterProvider.categoryId,
                  sortBy: sortBy.toString(),
                );

                ref
                    .read(productsFilterProvider.notifier)
                    .seteProductFilter(filterModel);

                ref.read(productsNotifierProvider.notifier).getProducts();
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                    value: item.value,
                    child: InkWell(
                      child: Text(item.label!),
                    ),
                  );
                }).toList();
              },
              icon: const Icon(Icons.filter_list_alt),
            ),
          )
        ],
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsNotifierProvider);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final productsViewModel = ref.read(productsNotifierProvider.notifier);
        final productsState = ref.watch(productsNotifierProvider);

        if (productsState.hasNext) {
          productsViewModel.getProducts();
        }
      }
    });

    if (productsState.products.isEmpty) {
      if (!productsState.hasNext && !productsState.isLoading) {
        return const Center(
          child: Text("No Products"),
        );
      }

      return const LinearProgressIndicator();
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productsNotifierProvider.notifier).refreshProduct();
      },
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 2,
              controller: _scrollController,
              children: List.generate(productsState.products.length, (index) {
                return ProductCard(
                  model: productsState.products[index],
                );
              }),
            ),
          ),
          // Show spinner
          Visibility(
            visible:
                productsState.isLoading && productsState.products.isNotEmpty,
            child: const SizedBox(
              height: 35,
              width: 35,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
