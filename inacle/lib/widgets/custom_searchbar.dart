import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inacle_app/constants/images.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const CustomSearchBar({super.key, required this.onSearch});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      widget.onSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.w),
              bottomLeft: Radius.circular(7.w),
              bottomRight: Radius.circular(7.w),
              topRight: Radius.circular(7.w),
            ),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.w),
              bottomLeft: Radius.circular(7.w),
              bottomRight: Radius.circular(7.w),
              topRight: Radius.circular(7.w),
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(1),
          hintText: 'Search Scheme Name..',
          hintStyle: TextStyle(
            fontFamily: 'Jost',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Image.asset(
            Images.searchIcon,
            width: 14.w,
            height: 14.h,
          ),
        ),
      ),
    );
  }
}
