import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/auth_page_layout.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    ref.listen(authViewModelProvider, (_, next) {
      if (next is Error) {
        displayError(context, next.message);
        emailController.clear();
        passwordController.clear();
      } else if (next is Success) {
        GoRouter.of(context).go(AppRoutes.home);
      }
    });

    void onLogin() {
      FocusScope.of(context).unfocus();
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        displayError(context, 'Please fill up all the fields');
        return;
      }
      viewModel.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }

    return authPageLayout(
      context: context,
      isLoading: state is Loading,
      form: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          headerText(text: 'LOG-IN'),
          const SizedBox(height: 30),
          _loginInputFieldWidgets(context, emailController, passwordController),
          _forgotPasswordWidget(context),
          const SizedBox(height: 30),
          authenticationButton('LOG-IN', onLogin, width: 170),
          const SizedBox(height: 30),
          _dontHaveAccountWidgets(context),
        ],
      ),
    );
  }

  Widget _loginInputFieldWidgets(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Column(
      children: [
        SizedBox(
          width: context.isCompactLayout
              ? context.screenSize.width * 0.85
              : context.screenSize.width * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: speechLabTextField('Email Address', emailController,
                    TextInputType.emailAddress, const Icon(Icons.email)),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: SpeechLabTextField(
                  text: 'Password',
                  controller: passwordController,
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

  Widget _forgotPasswordWidget(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Row(children: [
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(AppRoutes.reset);
                  },
                  child: const AutoSizeText('Forgot Password? ',
                      style: TextStyle(
                          color: AppColors.orchid,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  Widget _dontHaveAccountWidgets(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Wrap(alignment: WrapAlignment.center, children: [
        AutoSizeText('Don\'t Have an Account?', style: blackBoldStyle(size: 20)),
        TextButton(
            onPressed: () {
              GoRouter.of(context).go(AppRoutes.register);
            },
            child: const AutoSizeText('Register Now',
                style: TextStyle(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    color: AppColors.orchid,
                    fontWeight: FontWeight.bold)))
      ]),
    );
  }
}
