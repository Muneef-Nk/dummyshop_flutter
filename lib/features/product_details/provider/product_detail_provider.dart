import 'package:flutter/material.dart';
import '../model/product_details_model.dart';
import '../service/product_detail_service.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductDetailService _service = ProductDetailService();

  ProductDetailsModel? _product;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ProductDetailsModel? get product => _product;
  bool get loading => _isLoading;
  String? get error => _errorMessage;

  /// Fetch product details by ID
  Future<void> fetchProductDetail(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.fetchProductDetail(productId);
      _product = result;
    } catch (e, stack) {
      _errorMessage = 'Failed to load product detail';
      debugPrint('❌ Error fetching product detail: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear current product detail state
  void clear() {
    _product = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
