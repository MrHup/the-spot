import 'package:flutter/material.dart';

extension CustomExtension on Widget {
  Widget withPadding(final double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  Widget withPaddingTop(final double padding) {
    return Padding(padding: EdgeInsets.fromLTRB(0, padding, 0, 0), child: this);
  }

  Widget withPaddingBottom(final double padding) {
    return Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, padding), child: this);
  }

  Widget withPaddingTopBottom(final double padding) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, padding, 0, padding), child: this);
  }

  Widget withPaddingSides(final double padding) {
    return Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0), child: this);
  }

  Widget withExpanded(final flex) {
    return Expanded(child: this, flex: flex);
  }

  Widget centered() {
    return Center(child: this);
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
