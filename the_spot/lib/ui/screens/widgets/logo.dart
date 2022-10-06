import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
      child: Image(image: AssetImage('assets/img/logo.png')),
    );
  }
}
