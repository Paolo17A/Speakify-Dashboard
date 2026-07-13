import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';

export 'package:speechlab_dashboard/core/utils/app_colors.dart';

ThemeData get appThemeData => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orchid),
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.purple),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.orchid),
      textTheme: TextTheme(
          displayLarge: GoogleFonts.alata(),
          displayMedium: GoogleFonts.alata(),
          displaySmall: GoogleFonts.alata(),
          headlineLarge: GoogleFonts.alata(),
          headlineMedium: GoogleFonts.alata(),
          headlineSmall: GoogleFonts.alata(),
          titleLarge: GoogleFonts.alata(),
          titleMedium: GoogleFonts.alata(),
          titleSmall: GoogleFonts.alata(),
          bodyLarge: GoogleFonts.alata(),
          bodyMedium: GoogleFonts.alata(),
          bodySmall: GoogleFonts.alata(),
          labelLarge: GoogleFonts.alata(),
          labelMedium: GoogleFonts.alata(),
          labelSmall: GoogleFonts.alata()),
      listTileTheme: const ListTileThemeData(
          iconColor: AppColors.listTileIcon,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: WidgetStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)))),
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.orchid))));
