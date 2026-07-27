import 'package:flutter/widgets.dart';

extension BuildContextDirectionality on BuildContext {
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  bool get isLtr => Directionality.of(this) == TextDirection.ltr;
}
