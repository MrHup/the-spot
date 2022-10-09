import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:the_spot/ui/screens/dashboard.dart';
import 'package:the_spot/ui/screens/key_screen.dart';
import 'package:the_spot/ui/screens/login_screen.dart';
import 'package:the_spot/ui/screens/register_screen.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:wakelock/wakelock.dart';

void main() async {
  await dotenv.load();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  final tmpDir = await getTemporaryDirectory();
  // Hive.init(tmpDir.toString());
  await Hive.initFlutter();
  final storage = await HydratedStorage.build(
    storageDirectory: tmpDir,
  );
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
        '/login': (BuildContext context) => LoginScreen(),
        '/dashboard': (BuildContext context) => Dashboard(),
      },
      home: RegisterScreen(),
    );
  }
}
