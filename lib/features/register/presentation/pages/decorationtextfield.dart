import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFF333333),
    hintStyle: TextStyle(
      color: const Color(0xFFE0E0E0),
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: Color(0xFF444444)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
  );
}
