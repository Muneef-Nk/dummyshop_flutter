import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../../widgets/product_tile.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    provider.fetchProducts();

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 100 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              //
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              //
            },
          ),
          IconButton(
            onPressed: () {
              //
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => productProvider.fetchProducts(refresh: true),
        child: products.isEmpty && productProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollCtrl,
                itemCount: products.length + (productProvider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    return ProductTile(product: product);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
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
