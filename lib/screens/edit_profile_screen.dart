import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:speechlab_dashboard/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/widgets/left_navigator_widget.dart';
import 'package:speechlab_dashboard/widgets/speechLabTextField.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = true;
  Uint8List? currentSelectedFile;
  String profileImageURL = '';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUserData();
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

      _firstNameController.text = currentUserData.data()!['firstName'] ?? '';
      _lastNameController.text = currentUserData.data()!['lastName'] ?? '';
      profileImageURL = currentUserData.data()!['profileImageURL'] ?? '';
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error getting curent unser data: $error')));
    }
  }

  void updateUserProfile() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
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
      goRouter.go('/instructors');
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

  Widget _buildProfileImage() {
    if (currentSelectedFile != null) {
      return CircleAvatar(
          radius: 70, backgroundImage: MemoryImage(currentSelectedFile!));
    }
    if (profileImageURL != '') {
      return CircleAvatar(
        radius: 100,
        backgroundColor: const Color.fromARGB(255, 60, 19, 97),
        backgroundImage: NetworkImage(profileImageURL),
      );
    } else {
      return const CircleAvatar(
          radius: 100,
          backgroundColor: Color.fromARGB(255, 60, 19, 97),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitle(),
        body: Row(children: [
          lefNavigator(context, 2),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.85,
                    color: const Color.fromARGB(255, 82, 48, 124),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: _buildProfileImage(),
                            ),
                            if (currentSelectedFile != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        currentSelectedFile = null;
                                      });
                                    },
                                    child:
                                        const Text('Remove Selected Picture')),
                              ),
                            if (currentSelectedFile == null &&
                                profileImageURL != '')
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                    onPressed: _removeProfilePic,
                                    child:
                                        const Text('Remove Current Picture')),
                              ),
                            ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Upload Profile Picture')),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: speechLabTextField(
                                  'First Name',
                                  _firstNameController,
                                  TextInputType.name,
                                  null),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: speechLabTextField(
                                  'Last Name',
                                  _lastNameController,
                                  TextInputType.name,
                                  null),
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
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()))
              ],
            ),
          )
        ]));
  }
}
