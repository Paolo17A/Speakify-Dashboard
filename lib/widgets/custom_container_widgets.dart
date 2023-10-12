import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

Container bodyWidgetWhiteBG(BuildContext context, Widget child) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: child);
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
          color: Colors.black.withOpacity(0.5),
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
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1,
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Container(
          color: CustomColors.grimace,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.height * 0.01),
            child: Container(
              color: CustomColors.dirtyWhite,
              child: child,
            ),
          )),
    ),
  );
}

authenticationFormContainer(BuildContext context, Widget child) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05),
        child: roundedContainer(
            color: CustomColors.grimace,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: roundedContainer(
                  color: CustomColors.dirtyWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(child: child),
                  )),
            )),
      ));
}

Container roundedContainer(
    {required Widget child, Color? color, double? width, double? height}) {
  return Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: child);
}
