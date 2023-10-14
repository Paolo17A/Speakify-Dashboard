import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_miscellaneous_widgets.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color.fromARGB(255, 245, 245, 245),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75, bottom: 75),
                  child: speechLabLogo(size: 150),
                ),
                _getStartedButton(() => GoRouter.of(context).go('/register')),
                _alreadyHaveAccountButton(
                    () => GoRouter.of(context).go('/login'))
              ],
            ),
          )),
    );
  }

  Widget _getStartedButton(Function onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: SizedBox(
        width: 250,
        height: 60,
        child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: CustomColors.orchid),
            onPressed: () => onPress(),
            child: Text('GET STARTED', style: whiteBoldStyle(size: 30))),
      ),
    );
  }

  Widget _alreadyHaveAccountButton(Function onPress) {
    return TextButton(
        onPressed: () => onPress(),
        child: cambriaText(
            text: 'I ALREADY HAVE AN ACCOUNT',
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline)));
  }
}
