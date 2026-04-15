{{#ui_toolkit_material}}import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppTheme {
  AppTheme._();

  static ThemeDataData get light => ThemeDataData(
        colorScheme: ColorSchemes.defaultColorScheme,
        brightness: Brightness.light,
      );

  static ThemeDataData get dark => ThemeDataData(
        colorScheme: ColorSchemes.defaultColorScheme,
        brightness: Brightness.dark,
      );
}{{/ui_toolkit_shadcn}}
