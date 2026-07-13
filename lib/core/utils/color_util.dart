import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';

export 'package:speechlab_dashboard/core/utils/app_colors.dart';

ThemeData get appThemeData {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orchid,
      primary: AppColors.orchid,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBg,
  );

  return base.copyWith(
    snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.purple),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.orchid,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
    ),
    textTheme: GoogleFonts.alataTextTheme(base.textTheme),
    primaryTextTheme: GoogleFonts.alataTextTheme(base.primaryTextTheme),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.listTileIcon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.orchid),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        iconColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),
  );
}
