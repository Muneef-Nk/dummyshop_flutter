import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_list_service.dart';

class ProductListProvider with ChangeNotifier {
  final _service = ProductListService();

  final List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 20;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    if (refresh) {
      _skip = 0;
      _products.clear();
      _hasMore = true;
    }

    try {
      final newItems = await _service.fetchProducts(limit: _limit, skip: _skip);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newItems);
        _skip += _limit;
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
