import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/app_colors.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/appbar_title_widget.dart';
import 'package:speechlab_dashboard/core/widgets/left_navigator_widget.dart';

/// Shared authenticated layout: left rail on wide landscape, drawer on
/// compact / vertical screens. Optional [sidePanel] stacks under content
/// when compact instead of sitting as a right column.
class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.navIndex,
    required this.child,
    this.sidePanel,
  });

  final int navIndex;
  final Widget child;
  final Widget? sidePanel;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactLayout;

    if (compact) {
      return Scaffold(
        appBar: appBarTitle(showMenuButton: true),
        drawer: Drawer(
          backgroundColor: AppColors.love,
          child: SafeArea(
            child: lefNavigator(
              context,
              navIndex,
              mode: DashboardNavMode.drawer,
            ),
          ),
        ),
        body: ColoredBox(
          color: Colors.white,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      child,
                      if (sidePanel != null) ...[
                        const Divider(height: 1, thickness: 1),
                        SizedBox(
                          height: context.screenSize.height * 0.35,
                          child: sidePanel,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBarTitle(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          lefNavigator(context, navIndex, mode: DashboardNavMode.rail),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: child,
            ),
          ),
          if (sidePanel != null)
            SizedBox(
              width: context.screenSize.width * 0.2,
              child: ColoredBox(
                color: AppColors.love,
                child: sidePanel,
              ),
            ),
        ],
      ),
    );
  }
}
