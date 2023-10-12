import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                const SizedBox(height: 100),
                ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                            const Size(250, 60)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 60, 19, 97))),
                    onPressed: () {
                      GoRouter.of(context).go('/register');
                    },
                    child:
                        Text('GET STARTED', style: whiteBoldStyle(size: 30))),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      GoRouter.of(context).go('/login');
                    },
                    child: cambriaText(
                        text: 'I ALREADY HAVE AN ACCOUNT',
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline)))
              ],
            ),
          )),
    );
  }
}
