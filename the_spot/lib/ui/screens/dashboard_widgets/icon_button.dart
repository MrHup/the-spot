import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 50,
          maxHeight: 50,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppThemes.lightPanelColor,
            shape: const CircleBorder(
              side: BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: AppThemes.accentColor,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
