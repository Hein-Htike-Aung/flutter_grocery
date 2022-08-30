import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../config.dart';
import '../models/category/category.dart';
import '../models/product/product.dart';
import '../models/product/product_filter.dart';

// use river pod Provider & create dependency injection
final apiService = Provider((ref) => APIService());

class APIService {
  static Client client = http.Client();

  // ? is nullable
  Future<List<Category>?> getCategories(page, pageSize) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    Map<String, String> queryString = {
      'page': page.toString(),
      'pageSzie': pageSize.toString()
    };

    Uri url = Uri.http(Config.apiURL, Config.categoryAPI, queryString);

    Response response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return categoriesFromJson(data["data"]);
    } else {
      return null;
    }
  }

  Future<List<Product>?> getProducts(
      ProductFilterModel productFilterModel) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    Map<String, String> queryString = {
      'page': productFilterModel.paginationModel.page.toString(),
      'pageSzie': productFilterModel.paginationModel.pageSize.toString()
    };

    if (productFilterModel.categoryId != null) {
      queryString['categoryId'] = productFilterModel.categoryId!;
    }

    if (productFilterModel.sortBy != null) {
      queryString['sort'] = productFilterModel.sortBy!;
    }

    Uri url = Uri.http(Config.apiURL, Config.productAPI, queryString);

    Response response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return productFromJson(data["data"]);
    } else {
      return null;
    }
  }
}
