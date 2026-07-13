import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_padding_widgets.dart';

/// Main content surface. Prefer placing this inside [DashboardShell] so width
/// is driven by the shell (`Expanded`) rather than a fixed 80% of the screen.
Widget bodyWidgetWhiteBG(BuildContext context, Widget child) {
  final compact = context.isCompactLayout;
  return Container(
    width: compact ? double.infinity : context.contentMaxWidth(),
    constraints: BoxConstraints(
      minHeight: MediaQuery.sizeOf(context).height -
          (Scaffold.maybeOf(context)?.appBarMaxHeight ?? kToolbarHeight),
    ),
    color: Colors.white,
    child: child,
  );
}


Widget switchedLoadingContainer(bool isLoading, Widget child) {
  return isLoading ? const Center(child: CircularProgressIndicator()) : child;
}

Widget stackedLoadingContainer(
    BuildContext context, bool isLoading, List<Widget> child) {
  return Stack(children: [
    ...child,
    if (isLoading)
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withAlpha(128),
          child: const Center(child: CircularProgressIndicator()))
  ]);
}

Container authenticationBackgroundContainer(
    BuildContext context, Widget child) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_background.png'),
              fit: BoxFit.fill)),
      child: vertical10PercentHorizontal10Percent(context,
          child: Container(
              color: CustomColors.orchid,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.005,
                    horizontal: MediaQuery.of(context).size.height * 0.005),
                child: Container(
                  color: CustomColors.mercury,
                  child: child,
                ),
              ))));
}

authenticationFormContainer(BuildContext context, Widget child) {
  final compact = context.isCompactLayout;
  return SizedBox(
      width: compact
          ? MediaQuery.sizeOf(context).width * 0.9
          : MediaQuery.sizeOf(context).width * 0.25,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * (compact ? 0.02 : 0.05)),
        child: roundedContainer(
            color: CustomColors.orchid,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: roundedContainer(
                  color: CustomColors.mercury,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 12 : 20),
                      child: child,
                    ),
                  )),
            )),
      ));
}


Container roundedContainer(
    {required Widget child,
    Color? color,
    double? width,
    double? height,
    Color? borderColor}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: borderColor != null ? Border.all(color: borderColor) : null),
      child: child);
}

Container loveWineContainer(Widget child, {double? width, double? height}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: CustomColors.love,
          border: Border.all(color: CustomColors.orchid, width: 5)),
      child: child);
}

Container mercuryWineContainer(Widget child,
    {double? width, double? height, double borderWidth = 5}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: CustomColors.mercury,
          border: Border.all(color: CustomColors.orchid, width: borderWidth),
          borderRadius: BorderRadius.circular(10)),
      child: child);
}

Container whiteWineContainer(Widget child,
    {double? width, double? height, double borderWidth = 5}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CustomColors.orchid, width: borderWidth),
          borderRadius: BorderRadius.circular(10)),
      child: child);
}
