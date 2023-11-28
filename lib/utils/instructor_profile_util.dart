import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

import '../widgets/custom_padding_widgets.dart';
import '../widgets/speechLabTextField.dart';

void displayInstructorDialogue(BuildContext context,
    Map<dynamic, dynamic> instructorData, Function deleteInstructor) async {
  String profileImageURL = instructorData['profileImageURL'];
  String instructorName =
      '${instructorData['firstName']} ${instructorData['lastName']}';
  List<dynamic> handledSections = instructorData['handledSections'];
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: CustomColors.love,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      const SizedBox(height: 20),
                      //  PROFILE IMAGE
                      profileImageURL.isEmpty
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundColor: CustomColors.orchid,
                              child: Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              ))
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(profileImageURL)),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            instructorName,
                            textAlign: TextAlign.center,
                            style: wineBoldStyle(size: 40),
                          )),
                      Divider(thickness: 3),
                      Row(
                        children: [
                          Text(
                            'Handled Sections',
                            textAlign: TextAlign.center,
                            style: wineBoldStyle(size: 30),
                          ),
                        ],
                      ),
                      if (handledSections.isNotEmpty)
                        Row(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: handledSections
                                    .map((section) => Text(
                                          section,
                                          style: wineBoldStyle(),
                                        ))
                                    .toList()),
                          ],
                        )
                      else
                        Text('NO HANDLED SECTIONS', style: wineBoldStyle())
                    ]),
                    ElevatedButton(
                        onPressed: () => deleteInstructor(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 161, 11, 0)),
                        child: all20Pix(Text('Delete Instructor'))),
                    Gap(50),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('\tCLOSE\t')),
                  ]))));
}

void showAddInstructorDialog(
    BuildContext context,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    Function onAddInstructor) {
  firstNameController.clear();
  lastNameController.clear();
  emailController.clear();
  passwordController.clear();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomColors.love,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.orchid, width: 3)),
            child: SingleChildScrollView(
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'ADD INSTRUCTOR',
                    style: TextStyle(
                        color: CustomColors.orchid,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Text('First Name', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'First Name',
                      controller: firstNameController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text('Last Name', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'Last Name',
                      controller: lastNameController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text('Email Address', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'Email Address',
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text('Password', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'Password',
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: () => onAddInstructor(),
                      child: all20Pix(Text('ADD NEW INSTRUCTOR'))),
                  Gap(50),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('\tCLOSE\t')),
                ],
              )),
            ),
          ),
        );
      });
}

void showEditInstructorDialog(
    BuildContext context,
    Map<dynamic, dynamic> instructorData,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    Function onEditInstructor) {
  firstNameController.text = instructorData['firstName'];
  lastNameController.text = instructorData['lastName'];
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomColors.love,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.orchid, width: 3)),
            child: SingleChildScrollView(
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('EDIT INSTRUCTOR',
                      style: TextStyle(
                          color: CustomColors.orchid,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(children: [
                    Text('First Name', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'First Name',
                      controller: firstNameController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text('Last Name', style: wineBoldStyle(size: 30))
                  ]),
                  SpeechLabTextField(
                      text: 'Last Name',
                      controller: lastNameController,
                      textInputType: TextInputType.text,
                      displayPrefixIcon: null,
                      color: CustomColors.orchid),
                  const SizedBox(height: 45),
                  ElevatedButton(
                      onPressed: () => onEditInstructor(),
                      child: all20Pix(Text('EDIT INSTRUCTOR'))),
                  Gap(50),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('\tCLOSE\t')),
                ],
              )),
            ),
          ),
        );
      });
}
