import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/error_message.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/core/widgets/auth_page_layout.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';
import 'package:speechlab_dashboard/core/widgets/speechLabTextField.dart';
import 'package:speechlab_dashboard/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);
    final emailController = useTextEditingController();

    ref.listen(authViewModelProvider, (_, next) {
      if (next is Error) {
        emailController.clear();
        displayError(context, next.message);
      } else if (next is Success) {
        displaySuccess(context, 'Successfully sent password reset email!');
        GoRouter.of(context).go(AppRoutes.login);
      }
    });

    void onSendResetPassword() {
      if (!emailController.text.contains('@') ||
          !emailController.text.contains('.com')) {
        displayError(context, 'Please input a valid email address.');
        return;
      }
      viewModel.sendPasswordReset(email: emailController.text.trim());
    }

    return authPageLayout(
      context: context,
      isLoading: state is Loading,
      form: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          headerText(text: 'RESET YOUR PASSWORD'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: speechLabTextField(
              'Email Address',
              emailController,
              TextInputType.emailAddress,
              const Icon(Icons.email),
            ),
          ),
          authenticationButton(
            'RESET PASSWORD',
            onSendResetPassword,
            width: 250,
            height: 60,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
