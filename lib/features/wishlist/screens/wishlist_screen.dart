import 'package:dummyjson/features/products/models/product_model.dart';
import 'package:dummyjson/features/products/screens/product_detail_screen.dart';
import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../products/services/product_service.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _service = ProductService();
  List<ProductModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final ids = LocalStorage.getList('wishlist').map(int.parse).toList();
    final data = <ProductModel>[];

    for (var id in ids) {
      try {
        final p = await _service.fetchProductDetail(id);
        data.add(p);
      } catch (_) {}
    }

    setState(() {
      _items = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text('Your wishlist is empty 😔'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final p = _items[i];
                return ListTile(
                  leading: Image.network(p.thumbnail, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(p.title),
                  subtitle: Text('\$${p.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      wishlist.remove(p.id);
                      setState(() => _items.removeAt(i));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: p.id)),
                    );
                  },
                );
              },
            ),
    );
  }
}
