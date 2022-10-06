import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_spot/config/theme_data.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget(this.message, {super.key, this.onPressed});
  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(message,
            style: TextStyle(fontSize: 16, color: AppThemes.textSwatch)),
      ),
    );
  }
}
