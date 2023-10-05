import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                  child: CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/images/speechlab_logo.png'),
                  ),
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
                    child: const Text('GET STARTED')),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      GoRouter.of(context).go('/login');
                    },
                    child: const Text('I ALREADY HAVE AN ACCOUNT',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)))
              ],
            ),
          )),
    );
  }
}
