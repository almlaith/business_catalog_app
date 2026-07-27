import 'package:business_catalog_app/l10n/generated/app_localizations.dart';

enum OrderType {
  pickup,
  delivery;

  String label(AppLocalizations l10n) {
    return switch (this) {
      OrderType.pickup => l10n.pickup,
      OrderType.delivery => l10n.delivery,
    };
  }
}
