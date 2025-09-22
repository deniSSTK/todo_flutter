import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF81A4D9);
  static const primaryLight = Color(0xFFD8E9FF);
  static const primaryDark = Color(0xFF4C6B9A);
  static const background = Color(0xFFF5F5F5);
  static const doneTask = Color(0xFFDFF0D8);
  static const deleteIcon = Colors.red;
}

class AppFont {
  static const mid = 16.0;
}

class AppPadding {
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
}

class AppBorderRadius {
  static const small = 8.0;
  static const medium = 12.0;
}

class AppTextStyle {
  static const small = TextStyle(fontSize: 12);
  static const mid = TextStyle(fontSize: 16);
  static const taskDone = TextStyle(
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );
}

class AppAnimation {
  static const duration = Duration(milliseconds: 200);
}
