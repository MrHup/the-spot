import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';

class RegistrationHeader extends StatelessWidget {
  RegistrationHeader(this.text, {super.key});
  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: AppThemes.textSwatch,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
