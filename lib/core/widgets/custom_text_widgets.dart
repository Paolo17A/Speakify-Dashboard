import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';

AutoSizeText headerText({required String text, double fontSize = 30}) {
  return AutoSizeText(text,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: wineBoldStyle(size: fontSize));
}

TextStyle blackBoldStyle({double? size}) {
  return GoogleFonts.alata(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: size,
  );
}

TextStyle whiteBoldStyle({double? size}) {
  return GoogleFonts.alata(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: size,
  );
}

TextStyle wineBoldStyle({double? size}) {
  return GoogleFonts.alata(
    color: CustomColors.orchid,
    fontWeight: FontWeight.bold,
    fontSize: size,
  );
}

TextStyle wineRegularStyle({double? size}) {
  return GoogleFonts.alata(
    color: CustomColors.orchid,
    fontSize: size,
  );
}
