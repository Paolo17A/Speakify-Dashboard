import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_miscellaneous_widgets.dart';

/// Auth screens: side-by-side on landscape, stacked on vertical / compact.
Widget authPageLayout({
  required BuildContext context,
  required bool isLoading,
  required Widget form,
}) {
  final compact = context.isCompactLayout;
  final formBlock = SizedBox(
    height: context.screenSize.height * (compact ? 0.55 : 0.65),
    child: authenticationFormContainer(context, form),
  );

  final content = compact
      ? SingleChildScrollView(
          child: Column(
            children: [
              authenticationDesignImages(context),
              formBlock,
            ],
          ),
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            authenticationDesignImages(context),
            formBlock,
          ],
        );

  return Scaffold(
    body: stackedLoadingContainer(
      context,
      isLoading,
      [authenticationBackgroundContainer(context, content)],
    ),
  );
}
