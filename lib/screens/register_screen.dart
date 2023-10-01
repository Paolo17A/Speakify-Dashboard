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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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

      setState(() {
        _isLoading = false;
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
      });

      FirebaseAuth.instance
          .signOut()
          .then((value) => Navigator.pushNamed(context, '/login'));
    } on FirebaseAuthException catch (error) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        _isLoading = false;
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
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
              child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                                'assets/images/speechlab_logo.png')),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: const Center(
                            child: Text(
                              'SPEAKIFY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 124, 48, 114),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: const Color.fromARGB(255, 82, 48, 124),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('REGISTER',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40)),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      speechLabTextField(
                                          'Email Address',
                                          _emailController,
                                          TextInputType.emailAddress),
                                      const SizedBox(height: 5.0),
                                      SpeechLabTextField(
                                          text: 'Password',
                                          controller: _passwordController,
                                          textInputType:
                                              TextInputType.visiblePassword),
                                      const SizedBox(height: 5.0),
                                      SpeechLabTextField(
                                          text: 'Confirm Password',
                                          controller:
                                              _confirmPasswordController,
                                          textInputType:
                                              TextInputType.visiblePassword),
                                      const SizedBox(height: 40),
                                      speechLabTextField(
                                          'First Name',
                                          _firstNameController,
                                          TextInputType.name),
                                      const SizedBox(height: 5.0),
                                      speechLabTextField(
                                          'Last Name',
                                          _lastNameController,
                                          TextInputType.name),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                      onPressed: _registerUser,
                                      child: const Text(
                                        'REGISTER',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Have an Account?',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/login');
                                          },
                                          child: const Text(
                                            'Sign in',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Color.fromARGB(
                                                    255, 102, 58, 130),
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ]),
                              ]),
                        )),
                  )),
            ],
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
