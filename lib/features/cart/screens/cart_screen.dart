import 'package:dummyjson/features/products/models/product_model.dart';
import 'package:dummyjson/features/products/screens/product_detail_screen.dart';
import 'package:dummyjson/features/products/screens/product_list_screen.dart';
import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../products/services/product_service.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _service = ProductService();
  List<ProductModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final saved = LocalStorage.getList('cart');
    final data = <ProductModel>[];

    for (var entry in saved) {
      final parts = entry.split(':');
      if (parts.isNotEmpty) {
        final id = int.tryParse(parts.first);
        if (id != null) {
          try {
            final p = await _service.fetchProductDetail(id);
            data.add(p);
          } catch (e) {
            debugPrint('Failed to load product $id: $e');
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _items = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              cart.clear();
              setState(() => _items.clear());
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty 🛒', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => ProductListScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final p = _items[i];
                final qty = cart.getQuantity(p.id);

                return ListTile(
                  leading: Image.network(p.thumbnail, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(p.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${p.price}'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: qty > 1
                                ? () {
                                    cart.decreaseQuantity(p.id);
                                    setState(() {});
                                  }
                                : null,
                          ),
                          Text('$qty', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              cart.increaseQuantity(p.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      cart.remove(p.id);
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
      bottomNavigationBar: !_loading && _items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${cart.getTotal(_items).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
                ],
              ),
            )
          : null,
    );
  }
}
