import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/widgets/custom_container_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

import '../utils/error_message.dart';
import '../widgets/custom_miscellaneous_widgets.dart';
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
        'handledSections': []
      });

      await FirebaseFirestore.instance
          .collection('recentActivities')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': FirebaseAuth.instance.currentUser!.uid,
        'activityMessage':
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} just registered.'
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
          .then((value) => GoRouter.of(context).go('/login'));
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
    return Scaffold(
        body: stackedLoadingContainer(context, _isLoading, [
      authenticationBackgroundContainer(
          context,
          Row(
            children: [
              authenticationDesignImages(context),
              authenticationFormContainer(
                context,
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      headerText(text: 'REGISTER', fontSize: 25),
                      _registerInputFieldWidgets(),
                      authenticationButton('REGISTER', _registerUser,
                          height: 40),
                      const SizedBox(height: 10),
                      _haveAnAccountWidgets()
                    ]),
              )
            ],
          ))
    ]));
  }

  Widget _registerInputFieldWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: speechLabTextField('Email Address', _emailController,
                    TextInputType.emailAddress, const Icon(Icons.email)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: SpeechLabTextField(
                    text: 'Password',
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    displayPrefixIcon: const Icon(Icons.lock)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: SpeechLabTextField(
                    text: 'Confirm Password',
                    controller: _confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    displayPrefixIcon: const Icon(Icons.lock)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: speechLabTextField('First Name', _firstNameController,
                    TextInputType.name, const Icon(Icons.person_2)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: speechLabTextField('Last Name', _lastNameController,
                    TextInputType.name, const Icon(Icons.person_2)),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _haveAnAccountWidgets() {
    return Wrap(alignment: WrapAlignment.center, children: [
      AutoSizeText(
        'Have an Account?',
        style: blackBoldStyle(size: 20),
      ),
      TextButton(
          onPressed: () {
            GoRouter.of(context).go('/login');
          },
          child: AutoSizeText(
            'Sign in',
            style: const TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 102, 58, 130)),
          ))
    ]);
  }
}
