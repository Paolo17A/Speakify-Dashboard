import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/auth_page_layout.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();

    ref.listen(authViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        passwordController.clear();
        confirmPasswordController.clear();
      } else if (next is Success) {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        firstNameController.clear();
        lastNameController.clear();
        GoRouter.of(context).go(AppRoutes.login);
      }
    });

    void onRegister() {
      FocusScope.of(context).unfocus();
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty) {
        displayError(context, 'Please fill up all provided fields');
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        displayError(context, 'The passwords do not match');
        return;
      }
      viewModel.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );
    }

    return authPageLayout(
      context: context,
      isLoading: state is Loading,
      form: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            headerText(text: 'REGISTER', fontSize: 25),
            _registerInputFieldWidgets(
              context,
              emailController,
              passwordController,
              confirmPasswordController,
              firstNameController,
              lastNameController,
            ),
            authenticationButton('REGISTER', onRegister, height: 40),
            const SizedBox(height: 10),
            _haveAnAccountWidgets(context),
          ]),
    );
  }

  Widget _registerInputFieldWidgets(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
        SizedBox(
          width: context.isCompactLayout
              ? context.screenSize.width * 0.85
              : context.screenSize.width * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: speechLabTextField('Email Address', emailController,
                    TextInputType.emailAddress, const Icon(Icons.email)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: SpeechLabTextField(
                    text: 'Password',
                    controller: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    displayPrefixIcon: const Icon(Icons.lock)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: SpeechLabTextField(
                    text: 'Confirm Password',
                    controller: confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    displayPrefixIcon: const Icon(Icons.lock)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: speechLabTextField('First Name', firstNameController,
                    TextInputType.name, const Icon(Icons.person_2)),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 40,
                child: speechLabTextField('Last Name', lastNameController,
                    TextInputType.name, const Icon(Icons.person_2)),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _haveAnAccountWidgets(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: [
      AutoSizeText(
        'Have an Account?',
        style: blackBoldStyle(size: 20),
      ),
      TextButton(
          onPressed: () {
            GoRouter.of(context).go(AppRoutes.login);
          },
          child: const AutoSizeText(
            'Sign in',
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 102, 58, 130)),
          ))
    ]);
  }
}
