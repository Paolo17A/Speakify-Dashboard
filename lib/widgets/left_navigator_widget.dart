import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/utils/color_util.dart';
import 'package:speechlab_dashboard/widgets/custom_text_widgets.dart';

Widget lefNavigator(BuildContext context, int index, {bool isAdmin = false}) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
          color: CustomColors.love,
          border: Border.all(color: CustomColors.orchid, width: 2)),
      child: Column(children: [
        Flexible(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: index == 0 ? CustomColors.mercury : null,
                    border: Border.all(
                        color: index == 0
                            ? CustomColors.orchid
                            : CustomColors.love)),
                child: ListTile(
                  leading: const Icon(Icons.home, color: CustomColors.orchid),
                  title:
                      AutoSizeText('Dashboard', style: wineBoldStyle(size: 30)),
                  onTap: () => GoRouter.of(context).go('/home'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: index == 1 ? CustomColors.mercury : null,
                    border: Border.all(
                        color: index == 1
                            ? CustomColors.orchid
                            : CustomColors.love)),
                child: ListTile(
                  leading: const Icon(Icons.people, color: CustomColors.orchid),
                  title:
                      AutoSizeText('Students', style: wineBoldStyle(size: 30)),
                  onTap: () => GoRouter.of(context).go('/sections'),
                ),
              ),
              if (isAdmin)
                Container(
                  decoration: BoxDecoration(
                      color: index == 2 ? CustomColors.mercury : null,
                      border: Border.all(
                          color: index == 2
                              ? CustomColors.orchid
                              : CustomColors.love)),
                  child: ListTile(
                    leading:
                        const Icon(Icons.person_2, color: CustomColors.orchid),
                    title: AutoSizeText('All Instructors',
                        style: wineBoldStyle(size: 30)),
                    onTap: () => GoRouter.of(context).go('/instructors'),
                  ),
                )
              else if (!isAdmin)
                Container(
                  decoration: BoxDecoration(
                      color: index == 2 ? CustomColors.mercury : null,
                      border: Border.all(
                          color: index == 2
                              ? CustomColors.orchid
                              : CustomColors.love)),
                  child: ListTile(
                    leading:
                        const Icon(Icons.person_2, color: CustomColors.orchid),
                    title: AutoSizeText('My Profile',
                        style: wineBoldStyle(size: 30)),
                    onTap: () => GoRouter.of(context).go('/instructors/edit'),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                    color: index == 3 ? CustomColors.mercury : null,
                    border: Border.all(
                        color: index == 3
                            ? CustomColors.orchid
                            : CustomColors.love)),
                child: ListTile(
                    leading: const Icon(Icons.book_rounded,
                        color: CustomColors.orchid),
                    title:
                        AutoSizeText('Lessons', style: wineBoldStyle(size: 30)),
                    onTap: () => GoRouter.of(context).go('/lessons')),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            color: CustomColors.orchid,
          ),
          title: Text('Log Out', style: wineBoldStyle(size: 30)),
          onTap: () => FirebaseAuth.instance
              .signOut()
              .then((value) => GoRouter.of(context).go('/')),
        ),
      ]));
}
