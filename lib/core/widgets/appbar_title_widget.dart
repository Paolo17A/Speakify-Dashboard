import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/date_time_widget.dart';

PreferredSizeWidget appBarTitle({
  bool showMenuButton = false,
  bool showEndDrawerButton = false,
}) {
  return AppBar(
    foregroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    title: Builder(
      builder: (context) {
        final compact = context.isCompactLayout;
        final titleSize = compact ? 22.0 : 40.0;
        return Row(
          children: [
            if (!compact) const SizedBox(width: 10),
            Image.asset(
              'assets/images/speechlab_logo.png',
              scale: compact ? 14 : 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 30),
              child: Text(
                'SPEAKIFY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: titleSize,
                ),
              ),
            ),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [DateTimeDisplay()],
              ),
            ),
          ],
        );
      },
    ),
    leading: showMenuButton
        ? Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : null,
    actions: showEndDrawerButton
        ? [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.people_alt_outlined, color: Colors.white),
                tooltip: 'Active students',
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ]
        : null,
    automaticallyImplyLeading: false,
  );
}
