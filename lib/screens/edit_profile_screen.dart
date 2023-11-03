import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_padding_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';

import '../widgets/dropdown_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = true;
  bool _isInitialized = false;
  Uint8List? currentSelectedFile;
  String profileImageURL = '';
  String _originalFirstName = '';
  String _originalLastName = '';
  List<dynamic> handledSections = [];
  List<String> allSelectableSections = [];
  bool allSectionsHandled = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _currentSelectedSection = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) getCurrentUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  void getCurrentUserData() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final currentUserData = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      _originalFirstName = currentUserData.data()!['firstName'] ?? '';
      _firstNameController.text = _originalFirstName;
      _originalLastName = currentUserData.data()!['lastName'] ?? '';
      _lastNameController.text = _originalLastName;
      profileImageURL = currentUserData.data()!['profileImageURL'] ?? '';
      handledSections = currentUserData.data()!['handledSections'];

      final sections =
          await FirebaseFirestore.instance.collection('sections').get();
      allSelectableSections.clear();
      for (var sectionDoc in sections.docs) {
        if (!handledSections.contains(sectionDoc.id)) {
          allSelectableSections.add(sectionDoc.id);
        }
      }
      if (allSelectableSections.isEmpty) {
        allSectionsHandled = true;
      } else {
        allSectionsHandled = false;
      }
      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting curent unser data: $error')));
    }
  }

  void updateUserProfile() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    //final goRouter = GoRouter.of(context);
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Please fill up your first and last name')));
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<dynamic, dynamic> instructorData =
          instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} changed their name to ${_firstNameController.text.trim()} ${_lastNameController.text.trim()}.'
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim()
      });

      if (currentSelectedFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePics')
            .child(FirebaseAuth.instance.currentUser!.uid);

        final uploadTask = storageRef.putData(currentSelectedFile!);
        final taskSnapshot = await uploadTask.whenComplete(() {});
        final downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update the user's data in Firestore with the image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'profileImageURL': downloadURL,
        });

        await FirebaseFirestore.instance
            .collection('recentActivities')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          'dateAdded': DateTime.now(),
          'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
          'activityMessage':
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} changed their profile picture.'
        });
      }

      setState(() {
        _isLoading = false;
      });

      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Successfully updated user profile!')));
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error updating user profle: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() {
        currentSelectedFile = pickedFile;
      });
    }
  }

  void showAddSectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A SECTION TO HANDLE',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedSection, (selected) {
                    setState(() {
                      _currentSelectedSection = selected!;
                    });
                  }, allSelectableSections, _currentSelectedSection, false),
                  ElevatedButton(
                      onPressed: () => addSectionToHandle(),
                      child: all20Pix(Text('HANDLE THIS SECTION')))
                ],
              )),
            ),
          );
        });
  }

  void showRemoveSectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.love,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.wine, width: 3)),
              child: all20Pix(Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SELECT A SECTION TO REMOVE',
                    style: wineBoldStyle(size: 35),
                  ),
                  dropdownWidget(_currentSelectedSection, (selected) {
                    setState(() {
                      _currentSelectedSection = selected!;
                    });
                  }, List.from(handledSections), _currentSelectedSection,
                      false),
                  ElevatedButton(
                      onPressed: () => removeHandledSection(),
                      child: all20Pix(Text('REMOVE THIS SECTION')))
                ],
              )),
            ),
          );
        });
  }

  Future addSectionToHandle() async {
    if (_currentSelectedSection.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'handledSections': FieldValue.arrayUnion([_currentSelectedSection])
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(_currentSelectedSection)
          .update({
        'instructors':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} added ${_currentSelectedSection} to their handled sections.'
      });
      setState(() {
        _isLoading = false;
        _isInitialized = false;
      });
      getCurrentUserData();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  Future removeHandledSection() async {
    if (_currentSelectedSection.isEmpty) {
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    try {
      goRouter.pop();
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'handledSections': FieldValue.arrayRemove([_currentSelectedSection])
      });

      await FirebaseFirestore.instance
          .collection('sections')
          .doc(_currentSelectedSection)
          .update({
        'instructors':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} removed ${_currentSelectedSection} to their handled sections.'
      });
      setState(() {
        _isLoading = false;
        _isInitialized = false;
      });
      getCurrentUserData();
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error adding this section to handled sections: $error')));
    }
  }

  //  PROFILE PICS
  //============================================================================
  Widget _buildProfileImage() {
    if (currentSelectedFile != null) {
      return CircleAvatar(
          radius: 70, backgroundImage: MemoryImage(currentSelectedFile!));
    }
    if (profileImageURL != '') {
      return CircleAvatar(
        radius: 100,
        backgroundColor: CustomColors.wine,
        backgroundImage: NetworkImage(profileImageURL),
      );
    } else {
      return const CircleAvatar(
          radius: 100,
          backgroundColor: CustomColors.wine,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 80,
          ));
    }
  }

  Future<void> _removeProfilePic() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profileImageURL': ''});

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(FirebaseAuth.instance.currentUser!.uid);

      await storageRef.delete();

      final instructor = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<dynamic, dynamic> instructorData =
          instructor.data() as Map<dynamic, dynamic>;

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${instructorData['firstName']} ${instructorData['lastName']} removed their profile picture.'
      });

      setState(() {
        currentSelectedFile = null;
        profileImageURL = '';
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(
          content: Text('Error removing current profile pic: $error')));
      _firstNameController.clear();
      _lastNameController.clear();
      setState(() {
        currentSelectedFile = null;
        profileImageURL = '';
        _isLoading = false;
      });
    }
  }

  //  WIDGETS
  //============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 2),
          bodyWidgetWhiteBG(
              context,
              stackedLoadingContainer(context, _isLoading, [
                Row(
                  children: [_teacherProfileWidget(), _handledSectionsWidget()],
                ),
              ]))
        ]));
  }

  Widget _teacherProfileWidget() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: all20Pix(
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: _buildProfileImage(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      all8Pix(Text('$_originalFirstName $_originalLastName',
                          style: wineBoldStyle(size: 40))),
                      Row(children: [
                        if (currentSelectedFile != null)
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentSelectedFile = null;
                                  });
                                },
                                child: const Text('Remove Selected Picture')),
                          )
                        else if (profileImageURL != '')
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: _removeProfilePic,
                                child: const Text('Remove Current Picture')),
                          ),
                        ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Upload Profile Picture')),
                      ])
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: speechLabTextField('First Name', _firstNameController,
                    TextInputType.name, null),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: speechLabTextField(
                    'Last Name', _lastNameController, TextInputType.name, null),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 65,
                child: ElevatedButton(
                    onPressed: updateUserProfile,
                    child: const Text('SAVE CHANGES',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
              )
            ],
          ),
        ));
  }

  Widget _handledSectionsWidget() {
    return loveWineContainer(
        all20Pix(Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!allSectionsHandled)
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _currentSelectedSection = '';
                            showAddSectionDialog();
                          },
                          child: AutoSizeText(
                            'Add Section',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(),
                          ))),
                if (handledSections.isNotEmpty)
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _currentSelectedSection = '';
                            showRemoveSectionDialog();
                          },
                          child: AutoSizeText(
                            'Remove Section',
                            textAlign: TextAlign.center,
                            style: whiteBoldStyle(),
                          ))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Handled Sections:',
                style: wineBoldStyle(size: 30),
              ),
            ),
            handledSections.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: handledSections.length,
                    itemBuilder: (context, index) {
                      return all20Pix(SizedBox(
                        height: 75,
                        child: ElevatedButton(
                            onPressed: () => GoRouter.of(context)
                                    .goNamed('editSection', pathParameters: {
                                  'sectionName': handledSections[index]
                                }),
                            child: Text(handledSections[index],
                                style: whiteBoldStyle(size: 20))),
                      ));
                    })
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      'NO HANDLED SECTIONS',
                      textAlign: TextAlign.center,
                      style: wineBoldStyle(size: 30),
                    ),
                  )
          ],
        )),
        width: MediaQuery.of(context).size.width * 0.2);
  }
}
