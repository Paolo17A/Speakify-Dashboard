import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

Widget lefNavigator(BuildContext context, int index, {bool isAdmin = false}) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      color: CustomColors.jam,
      child: Column(children: [
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: index == 0 ? CustomColors.orchid : null,
                child: ListTile(
                  leading: const Icon(Icons.home, color: CustomColors.mercury),
                  title:
                      cambriaText(text: 'Dashboard', textStyle: _textStyle()),
                  onTap: () => GoRouter.of(context).go('/home'),
                ),
              ),
              Container(
                color: index == 1 ? CustomColors.orchid : null,
                child: ListTile(
                  leading:
                      const Icon(Icons.people, color: CustomColors.mercury),
                  title: cambriaText(text: 'Students', textStyle: _textStyle()),
                  onTap: () => GoRouter.of(context).go('/sections'),
                ),
              ),
              if (isAdmin)
                Container(
                  color: index == 2 ? CustomColors.orchid : null,
                  child: ListTile(
                    leading:
                        const Icon(Icons.person_2, color: CustomColors.mercury),
                    title: cambriaText(
                        text: 'All Instructors', textStyle: _textStyle()),
                    onTap: () => GoRouter.of(context).go('/instructors'),
                  ),
                )
              else if (!isAdmin)
                Container(
                  color: index == 2 ? CustomColors.orchid : null,
                  child: ListTile(
                    leading:
                        const Icon(Icons.person_2, color: CustomColors.mercury),
                    title: cambriaText(
                        text: 'My Profile', textStyle: _textStyle()),
                    onTap: () => GoRouter.of(context).go('/instructors/edit'),
                  ),
                ),
              Container(
                color: index == 3 ? CustomColors.orchid : null,
                child: ListTile(
                    leading: const Icon(Icons.book_rounded,
                        color: CustomColors.mercury),
                    title:
                        cambriaText(text: 'Lessons', textStyle: _textStyle()),
                    onTap: () => GoRouter.of(context).go('/lessons')),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text('Log Out', style: _textStyle()),
          onTap: () => FirebaseAuth.instance
              .signOut()
              .then((value) => GoRouter.of(context).go('/')),
        ),
      ]));
}

TextStyle _textStyle() {
  return const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
}
