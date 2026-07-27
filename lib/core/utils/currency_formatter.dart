import 'package:intl/intl.dart';

String formatCurrency(num value, {required String currencyCode}) {
  return NumberFormat.simpleCurrency(name: currencyCode).format(value);
}
