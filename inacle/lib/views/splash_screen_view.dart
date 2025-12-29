import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inacle_app/constants/images.dart';
import 'package:inacle_app/controllers/splash_controller.dart';
import 'package:inacle_app/theme.dart';
import 'package:inacle_app/widgets/app_loader.dart';

class SplashScreenView extends GetView<SplashController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo with subtle animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: Image.asset(Images.logo),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Version text
                Text(
                  Get.find<SplashController>().version,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Clean loader
                const AppLoader(
                  size: 36,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
