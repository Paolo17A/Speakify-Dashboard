import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    final navigator = Navigator.of(context);
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Please fill up your first and last name')));
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim()
      });
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Successfully updated user profile!')));
      navigator.pop();
      navigator.pushReplacementNamed('/instructors');
    } catch (error) {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error updating user profle: $error')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    if (profileImageURL != '') {
      return CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage(profileImageURL),
      );
    } else {
      return const CircleAvatar(radius: 100, child: Icon(Icons.person));
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
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.75,
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
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: speechLabTextField('First Name',
                                  _firstNameController, TextInputType.name),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: speechLabTextField('Last Name',
                                  _lastNameController, TextInputType.name),
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
