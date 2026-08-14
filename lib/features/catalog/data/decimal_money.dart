int decimalToCents(Object? value) {
  if (value is! num && value is! String) {
    throw const FormatException('Expected a decimal money value.');
  }
  final text = value.toString().trim();
  final match = RegExp(r'^(-?)(\d+)(?:\.(\d+))?$').firstMatch(text);
  if (match == null) {
    throw const FormatException('Invalid decimal money value.');
  }
  final fraction = match.group(3) ?? '';
  if (fraction.length > 2 && fraction.substring(2).contains(RegExp('[1-9]'))) {
    throw const FormatException('Money supports at most two decimal places.');
  }
  final cents =
      int.parse(match.group(2)!) * 100 +
      int.parse('${fraction}00'.substring(0, 2));
  return match.group(1) == '-' ? -cents : cents;
}

double decimalToMoney(Object? value) => decimalToCents(value) / 100;
