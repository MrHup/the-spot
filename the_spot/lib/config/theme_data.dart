import 'package:flutter/material.dart';

class AppThemes {
  static const int _primaryColor = 0xFF1C1B1F;
  static const MaterialColor primarySwatch =
      MaterialColor(_primaryColor, <int, Color>{
    50: Color(0xFF1C1B1F),
    100: Color(0xFF1C1B1F),
    200: Color(_primaryColor),
    300: Color(_primaryColor),
    400: Color(_primaryColor),
    500: Color(_primaryColor),
    600: Color(0xFF5B5EEF),
    700: Color(0xFF5153ED),
    800: Color(0xFF4749EB),
    900: Color(0xFF3538E7),
  });

  static const int _textColor = 0xFF22333B;
  static const TextStyle text_description_white = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle text_balance = TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle text_balance_currency = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle text_balance_currency_accent = TextStyle(
    color: AppThemes.accentColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle text_small_key = TextStyle(
    color: panelColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const Color accentColor = Color(0xFFa05891);
  static const Color panelColor = Color(0xFF2b2831);
  static const Color lightPanelColor = Color(0xFF49454f);
  static const Color darkPanelColor = Color(0xFF49454f);

  static const MaterialColor textSwatch =
      MaterialColor(_textColor, <int, Color>{
    50: Color(0xFFF9FAFB),
    100: Color(0xFFF3F4F6),
    200: Color(0xFFE5E7EB),
    300: Color(_textColor),
    400: Color(_textColor),
    500: Color(_textColor),
    600: Color(_textColor),
    700: Color(_textColor),
    800: Color(0xFF1C1B1F),
    900: Color(0xFF111827),
  });

  static const MaterialColor bubbleSwatch =
      MaterialColor(0xFF1C1B1F, <int, Color>{
    50: Color(0xFF1C1B1F),
  });

  static final lightTheme = ThemeData(
    primarySwatch: primarySwatch,
    brightness: Brightness.light,
    scaffoldBackgroundColor: textSwatch.shade100,
    backgroundColor: primarySwatch.shade100,
    cardColor: Colors.white,
    bottomAppBarColor: Colors.white,
    dividerColor: const Color(0x1C000000),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: textSwatch.shade700,
        fontWeight: FontWeight.w300,
      ),
      headline2: TextStyle(
        color: textSwatch.shade600,
      ),
      headline3: const TextStyle(
        color: Color.fromARGB(255, 35, 35, 39),
      ),
      headline4: TextStyle(
        color: textSwatch.shade700,
      ),
      headline5: TextStyle(
        color: textSwatch.shade600,
      ),
      headline6: TextStyle(
        color: textSwatch.shade700,
      ),
      subtitle1: TextStyle(
        color: textSwatch.shade700,
      ),
      subtitle2: TextStyle(
        color: textSwatch.shade600,
      ),
      bodyText1: TextStyle(
        color: textSwatch.shade700,
      ),
      bodyText2: TextStyle(
        color: textSwatch.shade500,
      ),
      button: TextStyle(
        color: textSwatch.shade500,
      ),
      caption: TextStyle(
        color: textSwatch.shade500,
      ),
      overline: TextStyle(
        color: textSwatch.shade500,
      ),
    ),
  );
}
