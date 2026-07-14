// import 'dart:math';
import 'package:fix_it/otp_page.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

import 'package:flutter/material.dart';
import 'package:fix_it/custom_textfiled.dart';
import 'package:fix_it/app_colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _fullnameContoller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isPasswordHidden = true;
  @override
  void dispose() {
    _fullnameContoller.dispose();
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
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100),
              Icon(
                //!this is the icon of page__________________________
                Icons.home_repair_service_rounded,
                size: 100,
                color: AppColors.primary,
              ),
              SizedBox(height: 24),
              // Text(
              //   "Welcome Back",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: AppColors.textPrimary,
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(height: 8),
              // Text(
              //   "login to continue the app ",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontFamily: 'Cairo',
              //     fontSize: 14,
              //     color: AppColors.textSecondary,
              //   ),
              // ),
              SizedBox(height: 40),
              //!this is the container have the textfield
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.12),
                      blurRadius: 20,
                      spreadRadius: 10,
                      offset: Offset(
                        0,
                        0,
                      ), // that mean the light around all the container
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //!this is the text field of fullname________________________
                    CustomTextField(
                      controller: _fullnameContoller,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person_2_outlined,
                    ),
                    SizedBox(height: 16),
                    //!this the text filed of phonenumber_____________________________
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    //!this is the text filed of email 
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

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
                          // تحديث الحالة لتبديل الرؤية
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    // Container(
                    //   padding: EdgeInsets.only(left: 150),
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "forget password ?",
                    //       textAlign: TextAlign.right,
                    //       style: TextStyle(
                    //         fontFamily: 'Cairo',
                    //         fontSize: 14,
                    //         color: AppColors.primary,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 24),
                 //!this is the button of register 
              ElevatedButton( 
              
                onPressed: () async {
                
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );

                  bool success = await authProvider.register(
                    _fullnameContoller.text,
                    _emailController.text,
                    _phoneController.text,
                    _passwordController.text,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register Success 🔥")),
                    );
                    //! if he success he will move you to otp page 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OtpPage(email: _emailController.text), //!and there we pass the email to otp page 
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register Failed ❌")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "create account",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already have account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
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
    );
  }
}
