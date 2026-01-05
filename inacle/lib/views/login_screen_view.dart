import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/login_controller.dart';
import 'package:inacle_app/theme.dart';
import 'package:inacle_app/widgets/app_button.dart';
import 'package:inacle_app/widgets/app_text_field.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(builder: (loginController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      Images.logo,
                      width: 180.w,
                      height: 90.h,
                    ),
                    const SizedBox(height: 32),

                    // Login Card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        boxShadow: AppTheme.elevatedShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome !',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please sign in to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // PAN Number Field
                          AppTextField(
                            controller: loginController.panCardController,
                            labelText: 'PAN Number',
                            hintText: 'Enter your PAN number',
                            prefixIcon: Icons.credit_card_outlined,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              UpperCaseTextFormatter(),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Mobile Number Field
                          AppTextField(
                            controller: loginController.mobileController,
                            labelText: 'Mobile Number',
                            hintText: 'Enter your mobile number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          AppTextField(
                            controller: loginController.emailController,
                            labelText: 'Email',
                            hintText: 'Enter your email address',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              loginController.onEmailChange(value);
                            },
                          ),
                          const SizedBox(height: 32),

                          // Login Button
                          AppButton(
                            text: 'Sign In',
                            width: double.infinity,
                            isLoading: loginController.isloading,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              loginController.login();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
