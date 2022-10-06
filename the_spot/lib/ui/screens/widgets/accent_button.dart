import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';

class AccentButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const AccentButton({this.text = "", this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          primary: AppThemes.accentColor,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        onPressed: (() {}),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
