import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/config/custom_extensions.dart';

class SimpleIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Icon icon;

  const SimpleIconButton(
      {this.text = "",
      this.onPressed,
      this.icon = const Icon(Icons.arrow_forward_ios),
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(10),
        primary: (CupertinoColors.systemGrey),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
