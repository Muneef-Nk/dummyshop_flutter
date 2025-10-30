import 'package:dummyjson/features/products/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dummyjson/core/storage/local_storaged.dart';

class CartProvider with ChangeNotifier {
  final Map<int, int> _quantities = {}; // productId -> quantity

  CartProvider() {
    _load();
  }

  Map<int, int> get quantities => _quantities;

  bool contains(int id) => _quantities.containsKey(id);

  void add(int id) {
    _quantities[id] = (_quantities[id] ?? 0) + 1;
    _save();
    notifyListeners();
  }

  void increaseQuantity(int id) {
    if (_quantities.containsKey(id)) {
      _quantities[id] = _quantities[id]! + 1;
      _save();
      notifyListeners();
    }
  }

  void decreaseQuantity(int id) {
    if (_quantities.containsKey(id)) {
      if (_quantities[id]! > 1) {
        _quantities[id] = _quantities[id]! - 1;
      } else {
        _quantities.remove(id);
      }
      _save();
      notifyListeners();
    }
  }

  void remove(int id) {
    _quantities.remove(id);
    _save();
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    _save();
    notifyListeners();
  }

  int getQuantity(int id) => _quantities[id] ?? 0;

  double getTotal(List<ProductModel> items) {
    double total = 0;
    for (var p in items) {
      total += p.price * getQuantity(p.id);
    }
    return total;
  }

  Future<void> _save() async {
    final list = _quantities.entries.map((e) => '${e.key}:${e.value}').toList();
    await LocalStorage.saveList('cart', list);
  }

  void _load() {
    final saved = LocalStorage.getList('cart');
    _quantities.clear();
    for (var e in saved) {
      final parts = e.split(':');
      if (parts.length == 2) {
        _quantities[int.parse(parts[0])] = int.parse(parts[1]);
      }
    }
  }
}
