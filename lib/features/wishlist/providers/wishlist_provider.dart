import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  List<int> _wishlistIds = [];

  WishlistProvider() {
    _load();
  }

  List<int> get wishlistIds => _wishlistIds;

  bool contains(int id) => _wishlistIds.contains(id);

  void add(int id) {
    _wishlistIds.add(id);
    _save();
  }

  void remove(int id) {
    _wishlistIds.remove(id);
    _save();
  }

  Future<void> _save() async {
    final ids = _wishlistIds.map((e) => e.toString()).toList();
    await LocalStorage.saveList('wishlist', ids);
    notifyListeners();
  }

  void _load() {
    final ids = LocalStorage.getList('wishlist');
    _wishlistIds = ids.map(int.parse).toList();
  }
}
