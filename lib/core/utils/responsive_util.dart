import 'package:flutter/material.dart';

/// Layout breakpoints for the SpeechLab Dashboard.
///
/// "Compact" covers portrait phones/tablets and narrow desktop windows where
/// the fixed 20%/60%/20% horizontal chrome no longer fits.
class DashboardBreakpoints {
  DashboardBreakpoints._();

  static const double compactMaxWidth = 900;
  static const double mediumMaxWidth = 1200;
}

extension DashboardResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  bool get isPortrait => screenSize.height >= screenSize.width;

  bool get isCompactWidth =>
      screenSize.width < DashboardBreakpoints.compactMaxWidth;

  /// Use stacked / drawer chrome on tall or narrow viewports.
  bool get isCompactLayout => isCompactWidth || isPortrait;

  bool get isMediumWidth =>
      screenSize.width >= DashboardBreakpoints.compactMaxWidth &&
      screenSize.width < DashboardBreakpoints.mediumMaxWidth;

  double contentMaxWidth({
    double wideFraction = 0.8,
    double compactPadding = 16,
  }) {
    if (isCompactLayout) {
      return (screenSize.width - compactPadding * 2).clamp(0, double.infinity);
    }
    return screenSize.width * wideFraction;
  }
}
