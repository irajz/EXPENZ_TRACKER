import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

enum FormMode { login, register }

class AuthScreen extends StatefulWidget {
  final FormMode mode;
  const AuthScreen({super.key, required this.mode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.mode == FormMode.register) {
        context.read<AuthProvider>().register(
              _nameController.text.trim(),
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      } else {
        context.read<AuthProvider>().login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.mode == FormMode.register;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  isRegister ? 'Enter your Personal Details' : 'Welcome Back',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),

                // Name (only for register)
                if (isRegister) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) => v!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 16),

                // Confirm password (only for register)
                if (isRegister) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) => v != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Remember Me
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: rememberMe,
                          onChanged: (v) => setState(() => rememberMe = v),
                          activeColor: const Color(0xFF6F43FF),
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    if (!isRegister)
                      TextButton(
                        onPressed: () {
                          context.go('location');
                        },
                        child: const Text('Forgot Password?'),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6F43FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      authProvider.isLoading
                          ? 'Please wait...'
                          : (isRegister ? 'Register' : 'Login'),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Switch between login/register
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.go(
                          '/auth?mode=${isRegister ? 'login' : 'register'}');
                    },
                    child: Text(
                      isRegister
                          ? 'Already have an account? Login'
                          : 'Don\'t have an account? Register',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
