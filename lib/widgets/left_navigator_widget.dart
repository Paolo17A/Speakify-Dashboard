import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget lefNavigator(BuildContext context, int index) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: const Color.fromARGB(255, 128, 75, 161),
      child: Column(children: [
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color:
                    index == 0 ? const Color.fromARGB(255, 86, 49, 109) : null,
                child: ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('Dashboard', style: _textStyle()),
                  onTap: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                ),
              ),
              Container(
                color:
                    index == 1 ? const Color.fromARGB(255, 86, 49, 109) : null,
                child: ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(
                    'Students',
                    style: _textStyle(),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/sections');
                  },
                ),
              ),
              Container(
                color:
                    index == 2 ? const Color.fromARGB(255, 86, 49, 109) : null,
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: Text('Instructor', style: _textStyle()),
                  onTap: () {
                    Navigator.pushNamed(context, '/instructors');
                  },
                ),
              ),
              Container(
                color:
                    index == 3 ? const Color.fromARGB(255, 86, 49, 109) : null,
                child: ListTile(
                  leading: const Icon(Icons.book_rounded),
                  title: Text('Lessons', style: _textStyle()),
                  onTap: () {
                    Navigator.pushNamed(context, '/lessons');
                  },
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text('Log Out', style: _textStyle()),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.popUntil(context, (route) => route.isFirst);
            });
          },
        ),
      ]));
}

TextStyle _textStyle() {
  return const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w200, color: Colors.white);
}
