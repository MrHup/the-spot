import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';

class IconButtonW extends StatelessWidget {
  const IconButtonW(
      {super.key, this.onPressed, this.icon = const Icon(Icons.abc_outlined)});

  final VoidCallback? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(10),
          primary: AppThemes.panelColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(
              width: 1,
              style: BorderStyle.solid,
              color: AppThemes.accentColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
