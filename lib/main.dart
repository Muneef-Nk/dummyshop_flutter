import 'package:dummyjson/features/product_details/provider/product_detail_provider.dart';
import 'package:dummyjson/features/profile/controllers/profile_controller.dart';
import 'package:dummyjson/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:dummyjson/features/auth/providers/auth_provider.dart';
import 'package:dummyjson/features/cart/providers/cart_provider.dart';
import 'package:dummyjson/features/products/providers/product_list_provider.dart';
import 'package:dummyjson/features/wishlist/providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductListProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DummyJSON App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
