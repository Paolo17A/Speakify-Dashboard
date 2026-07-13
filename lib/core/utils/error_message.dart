import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';

void displayError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 15),
      ),
      backgroundColor: AppColors.snackBarPurple));
}
