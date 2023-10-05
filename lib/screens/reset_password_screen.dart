import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/speechLabTextField.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ResetPasswordScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void _sendResetPassword() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final goRouter = GoRouter.of(context);
    if (!_emailController.text.contains('@') ||
        !_emailController.text.contains('.com')) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Please input a valid email address.')));
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final filteredUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (filteredUsers.docs.isEmpty) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('There is no user with that email address.')));
        return;
      }
      if (filteredUsers.docs.first.data()['userType'] != 'TEACHER') {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('This feature is for teachers only.')));
        return;
      }
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Successfully sent password reset email!')));
      goRouter.go('/login');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      scaffoldMessenger.showSnackBar(SnackBar(
          content:
              Text('Error sending password reset email: ${error.toString()}')));
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/images/speechlab_logo.png')),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
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
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Expanded(
                      child: Image.asset('assets/images/dashboard_welcome.png'),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.75,
                      color: const Color.fromARGB(255, 82, 48, 124),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: CircleAvatar(
                                          radius: 100,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                              'assets/images/speechlab_logo.png')),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text('RESET YOUR PASSWORD,',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25)),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          speechLabTextField(
                                              'Email Address',
                                              _emailController,
                                              TextInputType.emailAddress,
                                              const Icon(Icons.email)),
                                          const SizedBox(height: 5.0)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 200),
                                    SizedBox(
                                      height: 70,
                                      width: 250,
                                      child: ElevatedButton(
                                          onPressed: _sendResetPassword,
                                          child: const Text('RESET PASSWORD',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )
                                  ]))))),
                ],
              )),
        ],
      ),
      if (_isLoading)
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ))
    ]));
  }
}
