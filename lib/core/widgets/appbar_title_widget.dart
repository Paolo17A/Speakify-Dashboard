import 'package:flutter/material.dart';
import 'package:speechlab_dashboard/core/utils/responsive_util.dart';
import 'package:speechlab_dashboard/core/widgets/date_time_widget.dart';

PreferredSizeWidget appBarTitle({bool showMenuButton = false}) {
  return AppBar(
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
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : null,
    automaticallyImplyLeading: false,
  );
}
