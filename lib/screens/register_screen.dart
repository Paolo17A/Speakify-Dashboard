import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/error_message.dart';
import '../widgets/speechLabTextField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;

  void _registerUser() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      displayError(context, "Please fill up all provided fields");
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      displayError(context, "The passwords do not match");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'password': _passwordController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'userType': 'TEACHER',
        'profileImageURL': '',
      });

      FirebaseAuth.instance
          .signOut()
          .then((value) => Navigator.pushNamed(context, '/login'));
    } on FirebaseAuthException catch (error) {
      displayError(context, error.toString());
      setState(() {
        _isLoading = false;
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false;
      },
      child: Scaffold(
        body: Stack(children: [
          Center(
              child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.80,
                color: const Color.fromARGB(255, 60, 118, 141),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                      'assets/images/speakify_logo.png')),
                            ),
                            const SizedBox(height: 5),
                            const Text('REGISTER',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  speechLabTextField(
                                      'Email Address',
                                      _emailController,
                                      TextInputType.emailAddress),
                                  const SizedBox(height: 5.0),
                                  speechLabTextField(
                                      'Password',
                                      _passwordController,
                                      TextInputType.visiblePassword),
                                  const SizedBox(height: 5.0),
                                  speechLabTextField(
                                      'Confirm Password',
                                      _confirmPasswordController,
                                      TextInputType.visiblePassword),
                                  const SizedBox(height: 25),
                                  speechLabTextField('First Name',
                                      _firstNameController, TextInputType.name),
                                  const SizedBox(height: 5.0),
                                  speechLabTextField('Last Name',
                                      _lastNameController, TextInputType.name),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: _registerUser,
                                child: const Text('REGISTER')),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Have an Account?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 60, 118, 141),
                                            fontWeight: FontWeight.bold),
                                      ))
                                ]),
                          ])),
                )),
          )),
          if (_isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }
}
