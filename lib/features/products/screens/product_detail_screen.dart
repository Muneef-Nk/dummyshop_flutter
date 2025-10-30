import 'package:dummyjson/cart/providers/cart_provider.dart';
import 'package:dummyjson/features/cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _service = ProductService();
  ProductModel? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final data = await _service.fetchProductDetail(widget.productId);
      setState(() => _product = data);
    } catch (e) {
      setState(() => _error = 'Failed to load product');
      debugPrint('Error loading product: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error!)),
      );
    }

    if (_product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    final product = _product!;
    final isInCart = cart.contains(product.id);
    final isInWishlist = wishlist.contains(product.id);
    final qty = cart.getQuantity(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Image Carousel
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🏷️ Product Title & Price
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),

            // 🧾 Description
            Text(product.description, style: const TextStyle(fontSize: 15, height: 1.4)),
            const SizedBox(height: 24),

            // 🛒 Cart Controls
            if (isInCart)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                    onPressed: qty > 1
                        ? () {
                            cart.decreaseQuantity(product.id);
                            setState(() {});
                          }
                        : null,
                  ),
                  Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      cart.increaseQuantity(product.id);
                      setState(() {});
                    },
                  ),
                ],
              )
            else
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  onPressed: () {
                    cart.add(product.id);
                    setState(() {});
                  },
                ),
              ),
            const SizedBox(height: 24),

            // ❤️ Wishlist Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInWishlist ? Colors.pinkAccent : Colors.grey,
                ),
                icon: Icon(isInWishlist ? Icons.favorite : Icons.favorite_border),
                label: Text(isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist'),
                onPressed: () {
                  if (isInWishlist) {
                    wishlist.remove(product.id);
                  } else {
                    wishlist.add(product.id);
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
