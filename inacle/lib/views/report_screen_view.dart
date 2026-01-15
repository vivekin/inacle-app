import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/images.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String report = Get.arguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Image.asset(
            Images.logo,
            height: 36.h,
            width: 120.w,
          ),
        ),
        actions: const [],
      ),
      body: Center(
        child: Text('Report $report', style: TextStyle(fontSize: 20.sp)),
      ),
    );
  }
}
