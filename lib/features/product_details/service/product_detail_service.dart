import 'dart:convert';

import 'package:dummyjson/features/product_details/model/product_details_model.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/app_constants.dart';

class ProductDetailService {
  final _api = ApiClient();

  Future<ProductDetailsModel> fetchProductDetail(int id) async {
    final response = await _api.get('${AppConstants.products}/$id');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to load product detail');
    }
  }
}
