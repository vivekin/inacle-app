import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            // theme: AppTheme.lightTheme, // Use light theme
            // darkTheme: AppTheme.darkTheme, // Use dark theme when system dark mode is enabled
            initialRoute: AppRoutes
                .splash, // This is the route that the app will start on
            getPages: AppRoutes.routes, // Defined in routes.dart
          );
        });
  }
}
