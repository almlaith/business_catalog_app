import 'package:business_catalog_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension BuildContextDirectionality on BuildContext {
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  bool get isLtr => Directionality.of(this) == TextDirection.ltr;

  AppLocalizations get l10n => AppLocalizations.of(this);
}
