import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;

  static const page = EdgeInsets.all(lg);
  static const card = EdgeInsets.all(lg);
}

abstract final class AppRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 160);
  static const medium = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 360);
}

abstract final class AppIconSizes {
  static const sm = 18.0;
  static const md = 24.0;
  static const lg = 40.0;
}
