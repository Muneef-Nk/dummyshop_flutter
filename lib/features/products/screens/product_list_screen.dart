import 'package:dummyjson/features/cart/screens/cart_screen.dart';
import 'package:dummyjson/features/profile/view/profile_screen.dart';
import 'package:dummyjson/features/wishlist/screens/wishlist_screen.dart';
import 'package:dummyjson/widgets/product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';
import '../../../widgets/product_tile.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollCtrl = ScrollController();
  final Color _leafGreen = const Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductListProvider>();
    if (provider.products.isEmpty) {
      provider.fetchProducts();
    }

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 100 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.fetchProducts();
      }
    });
  }

  Widget _buildProductGridSliver(ProductListProvider productProvider) {
    final products = productProvider.products;

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductTile(product: product);
        },
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator(color: _leafGreen)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductListProvider>();
    final products = productProvider.products;
    final hasMore = productProvider.hasMore;

    final Widget shimmerGrid = SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: 8,
        itemBuilder: (context, index) => const ProductShimmer(),
      ),
    );

    return Scaffold(
      body: RefreshIndicator(
        color: _leafGreen,
        onRefresh: () async => productProvider.fetchProducts(refresh: true),
        child: CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.grey.withOpacity(0.2),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_leafGreen, _leafGreen.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _leafGreen.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Shop',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_rounded, color: Colors.red.shade400, size: 20),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WishlistScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_rounded, color: _leafGreen, size: 20),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    ),
                    icon: Icon(Icons.person_rounded, color: Colors.grey[700], size: 20),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),

            if (products.isEmpty && productProvider.isLoading)
              shimmerGrid
            else
              _buildProductGridSliver(productProvider),

            if (hasMore) _buildLoadingSliver(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }
}
