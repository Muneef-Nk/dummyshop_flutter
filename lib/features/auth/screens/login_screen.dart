import 'package:dummyjson/features/products/screens/product_list_screen.dart';
import 'package:dummyjson/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController(text: 'emilys');
  final _passwordCtrl = TextEditingController(text: 'emilyspass');
  final _formKey = GlobalKey<FormState>();

  final Color _leafGreen = const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context).copyWith(primaryColor: _leafGreen);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  'Access Your Account',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _leafGreen,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Enter your credentials to proceed.',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 50),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'e.g., john.doe',
                        prefixIcon: Icon(Icons.person_outline, color: _leafGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: _leafGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Username required' : null,
                    ),
                    const SizedBox(height: 25),

                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Secure password',
                        prefixIcon: Icon(Icons.lock_outline, color: _leafGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: _leafGreen, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Password required' : null,
                    ),
                    const SizedBox(height: 50),

                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? () {}
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await auth.login(
                                    _usernameCtrl.text.trim(),
                                    _passwordCtrl.text.trim(),
                                  );

                                  if (auth.error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(auth.error!),
                                        backgroundColor: Colors.red[400],
                                      ),
                                    );
                                  } else if (auth.isLoggedIn) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ProductListScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _leafGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 8,
                          shadowColor: _leafGreen.withOpacity(0.5),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
