import 'package:flutter/services.dart';

Future<void> configurePortraitOrientation() {
  return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
