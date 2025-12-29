import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inacle_app/common/hex_color.dart';
import 'package:inacle_app/constants/images.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String report = Get.arguments;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
            // backgroundColor: Color(0xFF1156A2),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: const [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    HexColor("#ffe2d0").withOpacity(0.8),
                    // HexColor("#ffe2d0"),
                    HexColor("#a98d7c").withOpacity(0.8),
                    // HexColor("#a98d7c"),
                  ],
                ),
              ),
            ),
            title: Container(
              margin: EdgeInsets.only(top: 16.h, left: 16.w),
              child: Image.asset(
                Images.logo,
                height: 35.58.h,
                width: 135.03.w,
              ),
            ),
            actions: [
              // Check if the function is provided
              // IconButton(
              //   icon: Icon(Icons.logout, color: Colors.black, size: 20.sp),
              //   onPressed: () {
              //      Get.find<StockInfoController>().logout();
              //   },
              // ),
            ]),
            body: Center(
              child:Text('Report $report', style: TextStyle(fontSize: 20.sp),),
            ),
    );
  }
}