import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

void displayInstructorDialogue(BuildContext context, String profileImageURL,
    String instructorName, bool isCurrentUser) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 115, 76, 162),
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
                if (isCurrentUser)
                  ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                        GoRouter.of(context).go('/instructors/edit');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text('EDIT PROFILE',
                            style: whiteBoldStyle(size: 20)),
                      ))
              ]))));
}
