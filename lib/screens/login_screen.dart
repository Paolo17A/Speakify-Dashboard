// ignore_for_file: use_build_context_synchronously

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
        displayError(context,
            'Students are not allowed to access the teacher\'s dashboard');

        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _isLoading = false;
        });
      } else if (currentUserData.data()!['userType'] == 'TEACHER') {
        Navigator.of(context).pushNamed('/home');
      }
    } on FirebaseAuthException catch (error) {
      displayError(context, 'Error logging in: $error');
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
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.75,
                  color: const Color.fromARGB(255, 82, 48, 124),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          child: SingleChildScrollView(
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
                                          'assets/images/speechlab_logo.png')),
                                ),
                                const SizedBox(height: 5),
                                const Text('LOG-IN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                const SizedBox(height: 10),
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
                                      speechLabTextField(
                                          'Password',
                                          _passwordController,
                                          TextInputType.visiblePassword),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/reset');
                                          },
                                          child: const Text('Forgot Password?',
                                              style: TextStyle(
                                                  color: Colors.purple,
                                                  decoration: TextDecoration
                                                      .underline)))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                      onPressed: _loginUser,
                                      child: const Text('LOG-IN',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t Have an Account?',
                                        style: TextStyle(
                                            fontSize: 25,
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
                                                fontSize: 25,
                                                color: Color.fromARGB(
                                                    255, 102, 58, 130),
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ])
                              ])))))),
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
