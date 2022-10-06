import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/key_screen.dart';
import 'package:the_spot/ui/screens/register_screen.dart';

void main() async {
  await dotenv.load();

  runApp(MainRouter());
}

class MainRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Spot',
      theme: AppThemes.lightTheme,
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => RegisterScreen(),
        '/key_generate': (BuildContext context) => KeyScreen(),
        '/login': (BuildContext context) => Container(),
      },
      home: RegisterScreen(),
    );
  }
}
