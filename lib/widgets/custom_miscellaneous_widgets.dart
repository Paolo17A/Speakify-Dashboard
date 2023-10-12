import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

Widget speechLabLogo({double? size}) {
  return CircleAvatar(
    radius: size,
    backgroundColor: Colors.transparent,
    child: Image.asset('assets/images/speechlab_logo.png'),
  );
}

Widget speechLabLogoWithText(BuildContext context) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            speechLabLogo(size: 50),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: const Center(
                child: Text(
                  'SPEAKIFY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustomColors.plum,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
            )
          ],
        ),
      ));
}

Widget authenticationDesignImages(BuildContext context) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.78,
      child: Column(
        children: [
          speechLabLogoWithText(context),
          Expanded(child: Image.asset('assets/images/dashboard_welcome.png')),
        ],
      ));
}
