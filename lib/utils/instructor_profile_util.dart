import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

void displayInstructorDialogue(
    BuildContext context, String profileImageURL, String instructorName) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: CustomColors.orchid,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(children: [
                const SizedBox(height: 20),
                //  PROFILE IMAGE
                profileImageURL.isEmpty
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Color.fromARGB(255, 53, 1, 36),
                        ))
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profileImageURL)),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Text(
                      instructorName,
                      textAlign: TextAlign.center,
                      style: whiteBoldStyle(size: 40),
                    )),
                const SizedBox(height: 50),
              ]))));
}
