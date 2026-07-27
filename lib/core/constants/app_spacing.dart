import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  static const page = EdgeInsets.all(lg);
  static const card = EdgeInsets.all(lg);
  static const screenHorizontal = 18.0;
  static const maxContentWidth = 560.0;
}

abstract final class AppRadii {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 26.0;
  static const xxl = 32.0;
  static const pill = 999.0;
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

abstract final class AppHeights {
  static const navDock = 74.0;
  static const action = 58.0;
  static const chip = 44.0;
  static const imageHeader = 330.0;
}
