import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

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
    final goRouter = GoRouter.of(context);
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
      } else if (currentUserData.data()!['userType'] == 'TEACHER' ||
          currentUserData.data()!['userType'] == 'ADMIN') {
        //navigator.pushNamed('/home');
        goRouter.go('/home');
      }
    } catch (error) {
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
    return Scaffold(
        body: stackedLoadingContainer(context, _isLoading, [
      authenticationBackgroundContainer(
        context,
        Row(
          children: [
            authenticationDesignImages(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: authenticationFormContainer(
                  context,
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //const SizedBox(height: 20),
                        headerText(text: 'LOG-IN'),
                        const SizedBox(height: 30),
                        _loginInputFieldWidgets(),
                        _forgotPasswordWidget(),
                        const SizedBox(height: 30),
                        authenticationButton('LOG-IN', _loginUser, width: 170),
                        const SizedBox(height: 30),
                        _dontHaveAccountWidgets()
                      ])),
            )
          ],
        ),
      )
    ]));
  }

  Widget _loginInputFieldWidgets() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: speechLabTextField('Email Address', _emailController,
                    TextInputType.emailAddress, const Icon(Icons.email)),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: SpeechLabTextField(
                  text: 'Password',
                  controller: _passwordController,
                  textInputType: TextInputType.visiblePassword,
                  displayPrefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _forgotPasswordWidget() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Row(children: [
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go('/reset');
                  },
                  child: AutoSizeText('Forgot Password? ',
                      style: const TextStyle(
                          color: CustomColors.fuschia,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  Widget _dontHaveAccountWidgets() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Wrap(alignment: WrapAlignment.center, children: [
        AutoSizeText('Don\'t Have an Account?',
            style: blackBoldStyle(size: 20)),
        TextButton(
            onPressed: () {
              GoRouter.of(context).go('/register');
            },
            child: AutoSizeText('Register Now',
                style: const TextStyle(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    color: CustomColors.fuschia,
                    fontWeight: FontWeight.bold)))
      ]),
    );
  }
}
