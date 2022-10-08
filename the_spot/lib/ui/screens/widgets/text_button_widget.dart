import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget(this.message,
      {super.key,
      this.onPressed,
      this.accentText = "",
      this.colorFirst = AppThemes.textSwatch});
  final String message;
  final String accentText;
  final VoidCallback? onPressed;
  final Color colorFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message, style: TextStyle(fontSize: 16, color: colorFirst)),
            const SizedBox(width: 5),
            Text(accentText,
                style: const TextStyle(
                    fontSize: 16,
                    color: AppThemes.accentColor,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
