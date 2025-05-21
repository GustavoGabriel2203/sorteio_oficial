import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h), 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16.h), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), 
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp, 
          ),
        ),
      ),
    );
  }
}
