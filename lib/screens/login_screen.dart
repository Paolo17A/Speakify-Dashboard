import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/error_message.dart';
import '../widgets/speechLabTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _loginUser() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      displayError(context, 'Please fill up all the fields');
      return;
    }
    final scaffoldState = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      final currentUserData = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (!currentUserData.data()!.containsKey('userType')) {
        scaffoldState.showSnackBar(
            const SnackBar(content: Text('No userType parameter found')));
        return;
      }

      if (currentUserData.data()!['userType'] == 'STUDENT') {
        scaffoldState.showSnackBar(const SnackBar(
            content: Text(
                'Students are not allowed to access the teacher\'s dashboard')));

        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _isLoading = false;
        });
      } else if (currentUserData.data()!['userType'] == 'TEACHER') {
        navigator.pushNamed('/home');
      }
    } on FirebaseAuthException catch (error) {
      scaffoldState
          .showSnackBar(SnackBar(content: Text('Error logging in: $error')));
      setState(() {
        _isLoading = false;
        _emailController.clear();
        _passwordController.clear();
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
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('LOG-IN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 45)),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/reset');
                                            },
                                            child: const Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    decoration: TextDecoration
                                                        .underline))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    height: 50,
                                    width: 125,
                                    child: ElevatedButton(
                                        onPressed: _loginUser,
                                        child: const Text('LOG-IN',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Don\'t Have an Account?',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/register');
                                              },
                                              child: const Text(
                                                'Register Now',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 102, 58, 130),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                        ]),
                                  )
                                ]),
                          )))),
            ],
          )),
          if (_isLoading)
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
        ])));
  }
}
