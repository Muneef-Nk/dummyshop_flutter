import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dummyjson/features/profile/controllers/profile_controller.dart';
import 'package:dummyjson/features/cart/screens/cart_screen.dart';
import 'package:dummyjson/features/wishlist/screens/wishlist_screen.dart';
import 'package:dummyjson/features/auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileController>(context, listen: false).fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    if (controller.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    final user = controller.user!;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(user.image)),
            const SizedBox(height: 12),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            _buildOption(context, Icons.shopping_cart, 'My Cart', const CartScreen()),
            _buildOption(context, Icons.favorite, 'My Wishlist', const WishlistScreen()),
            _buildOption(context, Icons.logout, 'Logout', null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String title,
    Widget? screen, {
    bool isLogout = false,
  }) {
    final controller = context.read<ProfileController>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.redAccent : Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.redAccent : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          if (isLogout) {
            await controller.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          } else if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          }
        },
      ),
    );
  }
}
