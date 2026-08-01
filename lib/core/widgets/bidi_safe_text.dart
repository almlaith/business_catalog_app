import 'package:flutter/material.dart';

/// Renders mixed business and catalog values in their natural reading order
/// without changing the direction of the surrounding layout.
class BidiSafeText extends StatelessWidget {
  const BidiSafeText(
    this.data, {
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.forceDirection,
    super.key,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextDirection? forceDirection;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      textDirection:
          forceDirection ?? bidiTextDirection(data, Directionality.of(context)),
    );
  }
}

TextDirection bidiTextDirection(String value, TextDirection fallback) {
  for (final rune in value.runes) {
    if (_isArabicRune(rune)) {
      return TextDirection.rtl;
    }
    if (_isLatinRune(rune)) {
      return TextDirection.ltr;
    }
  }

  return RegExp(r'[0-9]').hasMatch(value) ? TextDirection.ltr : fallback;
}

bool _isLatinRune(int rune) =>
    (rune >= 0x0041 && rune <= 0x005A) || (rune >= 0x0061 && rune <= 0x007A);

bool _isArabicRune(int rune) =>
    (rune >= 0x0600 && rune <= 0x06FF) ||
    (rune >= 0x0750 && rune <= 0x077F) ||
    (rune >= 0x08A0 && rune <= 0x08FF) ||
    (rune >= 0xFB50 && rune <= 0xFDFF) ||
    (rune >= 0xFE70 && rune <= 0xFEFF);
