import 'package:flutter/material.dart';

class AppColors {
  static const Color orchid = Color.fromARGB(255, 132, 7, 84);
  static const Color love = Color.fromARGB(255, 240, 235, 238);
  static const Color mercury = Color.fromARGB(255, 255, 255, 255);
  static const Color scaffoldBg = Color.fromARGB(255, 245, 245, 245);
  static const Color listTileIcon = Color.fromARGB(255, 180, 145, 200);
  static const Color snackBarPurple = Colors.deepPurple;
}

/// Legacy alias used by existing widgets during migration.
class CustomColors {
  static const Color orchid = AppColors.orchid;
  static const Color love = AppColors.love;
  static const Color mercury = AppColors.mercury;
}
