import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return Scaffold(
      body: Container(
          color: AppColors.scaffoldBg,
          alignment: Alignment.center,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: compact ? 40 : 75,
                      bottom: compact ? 40 : 75,
                    ),
                    child: speechLabLogo(size: compact ? 110 : 150),
                  ),
                  _getStartedButton(
                      () => GoRouter.of(context).go(AppRoutes.register)),
                  _alreadyHaveAccountButton(
                      () => GoRouter.of(context).go(AppRoutes.login))
                ],
              ),
            ),
          )),
    );
  }

  Widget _getStartedButton(VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: SizedBox(
        width: 250,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orchid),
            onPressed: onPress,
            child: Text('GET STARTED', style: whiteBoldStyle(size: 30))),
      ),
    );
  }

  Widget _alreadyHaveAccountButton(VoidCallback onPress) {
    return TextButton(
        onPressed: onPress,
        child: const AutoSizeText('I ALREADY HAVE AN ACCOUNT',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline)));
  }
}
