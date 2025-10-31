import 'dart:convert';
import '../../../core/api/api_client.dart';
import '../../../core/utils/app_constants.dart';
import '../models/product_model.dart';

class ProductListService {
  final _api = ApiClient();

  Future<List<ProductModel>> fetchProducts({int limit = 20, int skip = 0}) async {
    final response = await _api.get('${AppConstants.products}?limit=$limit&skip=$skip');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];
      return products.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
