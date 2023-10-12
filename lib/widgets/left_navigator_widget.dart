import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';

Widget lefNavigator(BuildContext context, int index) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: CustomColors.wine,
      child: Column(children: [
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: index == 0 ? CustomColors.darkWine : null,
                child: ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('Dashboard', style: _textStyle()),
                  onTap: () {
                    GoRouter.of(context).go('/home');
                  },
                ),
              ),
              Container(
                color: index == 1 ? CustomColors.darkWine : null,
                child: ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(
                    'Students',
                    style: _textStyle(),
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/sections');
                  },
                ),
              ),
              Container(
                color: index == 2 ? CustomColors.darkWine : null,
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: Text('Instructor', style: _textStyle()),
                  onTap: () {
                    GoRouter.of(context).go('/instructors');
                  },
                ),
              ),
              Container(
                color: index == 3 ? CustomColors.darkWine : null,
                child: ListTile(
                  leading: const Icon(Icons.book_rounded),
                  title: Text('Lessons', style: _textStyle()),
                  onTap: () {
                    GoRouter.of(context).go('/lessons');
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
              GoRouter.of(context).go('/');
            });
          },
        ),
      ]));
}

TextStyle _textStyle() {
  return const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w200, color: Colors.white);
}
