import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer appDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: Text('Dashboard', style: _textStyle()),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: Text(
                  'Students',
                  style: _textStyle(),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/leaderboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text('Instructor', style: _textStyle()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text('Lessons', style: _textStyle()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text('Log Out', style: _textStyle()),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.popUntil(context, (route) => route.isFirst);
            });
          },
        ),
      ],
    ),
  );
}

TextStyle _textStyle() {
  return const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
}
