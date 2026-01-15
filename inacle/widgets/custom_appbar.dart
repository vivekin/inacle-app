// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inacle_app/constants/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showImageTitle;
  final bool showBackButton;
  final String textTitle;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onActionButtonPressed;
  final IconData icon;

  const CustomAppBar({
    super.key,
    required this.showImageTitle,
    this.showBackButton = true,
    required this.textTitle,
    this.onBackButtonPressed,
    this.onActionButtonPressed,
    this.icon = Icons.settings,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.w);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF1156A2),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon:
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
              onPressed:
                  onBackButtonPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: showImageTitle
          ? Container(
              margin: EdgeInsets.only(top: 16.h, left: 16.w),
              child: Image.asset(
                Images.logo,
                height: 27.58.h,
                width: 127.03.w,
              ),
            )
          : Text(
              textTitle,
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontFamily: 'Jost',
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                height: 31.79 / 22.sp,
              ),
              textAlign: TextAlign.left,
            ),
      actions: onActionButtonPressed != null
          ? [
              // Check if the function is provided
              IconButton(
                icon: Icon(icon, color: Colors.white, size: 20.sp),
                onPressed: onActionButtonPressed,
              ),
            ]
          : null, // If the function is not provided, don't display the button
    );
  }
}
