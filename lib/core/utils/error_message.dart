import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';

void displayError(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.snackBarPurple,
    textColor: Colors.white,
    fontSize: 15,
    timeInSecForIosWeb: 3,
  );
}

void displaySuccess(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green.shade700,
    textColor: Colors.white,
    fontSize: 15,
    timeInSecForIosWeb: 2,
  );
}
