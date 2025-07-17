import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension ResponsiveBuildContextExtension on BuildContext {
  ResponsiveBreakpointsData get responsive => ResponsiveBreakpoints.of(this);
}
