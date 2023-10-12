import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

import '../widgets/custom_miscellaneous_widgets.dart';
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
        body: stackedLoadingContainer(
      context,
      _isLoading,
      [
        authenticationBackgroundContainer(
            context,
            Row(
              children: [
                authenticationDesignImages(context),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: authenticationFormContainer(
                      context,
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.48,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              headerText(text: 'RESET YOUR PASSWORD'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: speechLabTextField(
                                    'Email Address',
                                    _emailController,
                                    TextInputType.emailAddress,
                                    const Icon(Icons.email)),
                              ),
                              authenticationButton(
                                  'RESET PASSWORD', _sendResetPassword,
                                  width: 250, height: 60),
                              const SizedBox(height: 10),
                            ]),
                      ),
                    ))
              ],
            ))
      ],
    ));
  }
}
