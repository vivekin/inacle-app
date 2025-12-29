import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/common/fade_animation.dart';
import 'package:inacle_app/constants/app_constants.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/otp_controller.dart';
import 'package:inacle_app/repositories/auth_repository.dart';
import 'package:inacle_app/theme.dart';
import 'package:inacle_app/widgets/app_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends GetView<OTPController> {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserRepository());
    Get.lazyPut(() => OTPController());
    return Scaffold(
      body: GetBuilder<OTPController>(builder: (otpController) {
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
                    FadeAnimation(
                      delay: 0.8,
                      child: Image.asset(
                        Images.logo,
                        width: 180.w,
                        height: 90.h,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP Card
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Verification Code',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Enter the code sent to',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${AppConstants.user.emailID}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // OTP Input
                          Form(
                            key: otpController.formKey,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              autoFocus: true,
                              obscureText: true,
                              obscuringCharacter: '●',
                              blinkWhenObscuring: true,
                              animationType: AnimationType.scale,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                fieldHeight: 56,
                                fieldWidth: 56,
                                selectedFillColor: AppTheme.primaryColor.withOpacity(0.05),
                                activeFillColor: Colors.white,
                                inactiveFillColor: AppTheme.surfaceColor,
                                selectedColor: AppTheme.primaryColor,
                                activeColor: AppTheme.primaryColor,
                                inactiveColor: AppTheme.dividerColor,
                              ),
                              cursorColor: AppTheme.primaryColor,
                              animationDuration: const Duration(milliseconds: 250),
                              enableActiveFill: true,
                              errorAnimationController: otpController.errorController,
                              controller: otpController.textEditingController,
                              keyboardType: TextInputType.number,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              onChanged: (value) {
                                otpController.onChanged(value);
                              },
                              beforeTextPaste: (text) => true,
                            ),
                          ),

                          if (otpController.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Please enter a valid code',
                                style: TextStyle(
                                  color: AppTheme.errorColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          // Resend Code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: otpController.isResendButtonEnabled
                                    ? () {
                                        otpController.snackBar("OTP resent!", context);
                                        otpController.startTimer();
                                      }
                                    : null,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  otpController.isResendButtonEnabled
                                      ? "Resend"
                                      : "Resend in ${otpController.start}s",
                                  style: TextStyle(
                                    color: otpController.isResendButtonEnabled
                                        ? AppTheme.primaryColor
                                        : AppTheme.textLight,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Verify Button
                          AppButton(
                            text: 'Verify',
                            width: double.infinity,
                            isLoading: otpController.isloading,
                            onPressed: () {
                              otpController.otpValidation(context);
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
