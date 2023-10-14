import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

AutoSizeText cambriaText({required String text, TextStyle? textStyle}) {
  return AutoSizeText(text,
      overflow: TextOverflow.clip,
      maxLines: 2,
      style: GoogleFonts.oranienbaum(textStyle: textStyle));
}

AutoSizeText headerText({required String text}) {
  return AutoSizeText(text,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: blackBoldStyle(size: 45));
}

TextStyle blackBoldStyle({double? size}) {
  return TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: size);
}

TextStyle whiteBoldStyle({double? size}) {
  return TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: size);
}

AutoSizeText cambriaWineHeaderText({required String text}) {
  return cambriaText(
      text: text,
      textStyle: const TextStyle(
          fontSize: 70, fontWeight: FontWeight.bold, color: CustomColors.wine));
}
