import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speechlab_dashboard/core/utils/app_routes.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/custom_buttons_widget.dart';
import 'package:speechlab_dashboard/core/widgets/dashboard_shell.dart';
import 'package:speechlab_dashboard/features/home/presentation/widgets/active_students_widget.dart';
import 'package:speechlab_dashboard/features/home/presentation/widgets/recent_activities_widget.dart';
import 'package:speechlab_dashboard/features/home/presentation/widgets/section_students_count_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;
    return DashboardShell(
      navIndex: 0,
      sidePanel: const ActiveStudentsWidget(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 0,
          vertical: compact ? 8 : 0,
        ),
        child: Column(
          children: [
            _homeDashboardRowWidgets(context),
            const SectionStudentsCountWidget(),
            const RecentActiviesWidget(),
          ],
        ),
      ),
    );
  }

  Widget _homeDashboardRowWidgets(BuildContext context) {
    final compact = context.isCompactLayout;
    final buttonWidth =
        compact ? context.screenSize.width * 0.28 : context.screenSize.width * 0.15;
    final buttonHeight =
        compact ? 72.0 : context.screenSize.width * 0.10;

    final buttons = [
      ('SCORES', AppRoutes.scores),
      ('QUIZZES', AppRoutes.quizzes),
      ('RANKING', AppRoutes.ranking),
    ];

    final children = buttons
        .map(
          (entry) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: homeDashboardRowButton(
              buttonWidth,
              buttonHeight,
              () => GoRouter.of(context).go(entry.$2),
              entry.$1,
            ),
          ),
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 40),
      child: compact
          ? Wrap(
              alignment: WrapAlignment.center,
              children: children,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
    );
  }
}
