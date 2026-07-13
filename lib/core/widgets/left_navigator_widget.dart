import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/session/auth_session_notifier.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/widgets/custom_text_widgets.dart';

enum DashboardNavMode { rail, drawer }

/// Left navigation rail (wide) or drawer list (compact / vertical).
Widget lefNavigator(
  BuildContext context,
  int index, {
  DashboardNavMode mode = DashboardNavMode.rail,
}) {
  return Consumer(builder: (context, ref, _) {
    final isAdmin = ref.watch(authSessionProvider).isAdmin;
    final isDrawer = mode == DashboardNavMode.drawer;
    final titleSize = isDrawer ? 22.0 : 30.0;

    Future<void> go(String route) async {
      if (isDrawer && Scaffold.maybeOf(context)?.isDrawerOpen == true) {
        Navigator.of(context).pop();
      }
      GoRouter.of(context).go(route);
    }

    final items = <Widget>[
      _navTile(
        selected: index == 0,
        icon: Icons.home,
        title: 'Dashboard',
        titleSize: titleSize,
        onTap: () => go(AppRoutes.home),
      ),
      _navTile(
        selected: index == 1,
        icon: Icons.people,
        title: 'Students',
        titleSize: titleSize,
        onTap: () => go(AppRoutes.sections),
      ),
      if (isAdmin)
        _navTile(
          selected: index == 2,
          icon: Icons.person_2,
          title: 'All Instructors',
          titleSize: titleSize,
          onTap: () => go(AppRoutes.instructors),
        )
      else
        _navTile(
          selected: index == 2,
          icon: Icons.person_2,
          title: 'My Profile',
          titleSize: titleSize,
          onTap: () => go(AppRoutes.instructorsEdit),
        ),
      _navTile(
        selected: index == 3,
        icon: Icons.book_rounded,
        title: 'Lessons',
        titleSize: titleSize,
        onTap: () => go(AppRoutes.lessons),
      ),
    ];

    final logout = ListTile(
      leading: const Icon(Icons.exit_to_app, color: AppColors.orchid),
      title: Text('Log Out', style: wineBoldStyle(size: titleSize)),
      onTap: () async {
        if (isDrawer && Scaffold.maybeOf(context)?.isDrawerOpen == true) {
          Navigator.of(context).pop();
        }
        await ref.read(authSessionProvider.notifier).clear();
        if (context.mounted) {
          GoRouter.of(context).go(AppRoutes.welcome);
        }
      },
    );

    if (isDrawer) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Image.asset('assets/images/speechlab_logo.png', scale: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('SPEAKIFY',
                      style: wineBoldStyle(size: 22),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: ListView(children: items)),
          const Divider(height: 1),
          logout,
        ],
      );
    }

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.2,
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 280),
      decoration: BoxDecoration(
        color: AppColors.love,
        border: Border.all(color: AppColors.orchid, width: 2),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: ListView(padding: EdgeInsets.zero, children: items),
          ),
          logout,
        ],
      ),
    );
  });
}

Widget _navTile({
  required bool selected,
  required IconData icon,
  required String title,
  required double titleSize,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: selected ? AppColors.mercury : null,
      border: Border.all(
        color: selected ? AppColors.orchid : AppColors.love,
      ),
    ),
    child: ListTile(
      leading: Icon(icon, color: AppColors.orchid),
      title: AutoSizeText(title,
          maxLines: 1, style: wineBoldStyle(size: titleSize)),
      onTap: onTap,
    ),
  );
}
