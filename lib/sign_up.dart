import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/login_page.dart';
import 'package:fix_it/otp_page.dart';
import 'package:fix_it/custom_textfiled.dart';
import 'package:fix_it/app_colors.dart';
import 'providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullnameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 100),

                const Icon(
                  Icons.home_repair_service_rounded,
                  size: 100,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 24),

                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: AppColors.surface,

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),

                      width: 1.5,
                    ),
                  ),

                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _fullnameController,

                        hintText: 'Full Name',

                        prefixIcon: Icons.person_2_outlined,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }

                          if (value.trim().length < 3) {
                            return 'Name is too short';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _phoneController,

                        hintText: 'Phone Number',

                        prefixIcon: Icons.phone_outlined,

                        keyboardType: TextInputType.phone,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }

                          if (value.length < 8) {
                            return 'Invalid phone number';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,

                        hintText: 'Email',

                        prefixIcon: Icons.email_outlined,

                        keyboardType: TextInputType.emailAddress,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }

                          if (!value.contains('@')) {
                            return 'Invalid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,

                        hintText: 'Password',

                        prefixIcon: Icons.lock_outline,

                        obscureText: _isPasswordHidden,

                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: AppColors.textSecondary,
                          ),

                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final success = await authProvider.register(
                                _fullnameController.text,

                                _emailController.text,

                                _phoneController.text,

                                _passwordController.text,
                              );

                              if (!context.mounted) return;

                              if (success) {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OtpPage(email: _emailController.text),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.authError ??
                                          "Register Failed",

                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),

                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,

                        padding: const EdgeInsets.symmetric(vertical: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Create Account",

                              style: TextStyle(
                                fontFamily: 'Cairo',

                                fontSize: 16,

                                fontWeight: FontWeight.bold,

                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Already have account?",

                      style: TextStyle(color: AppColors.textSecondary),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },

                      child: const Text(
                        "Sign In",

                        style: TextStyle(
                          fontFamily: 'Cairo',

                          color: AppColors.primary,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
