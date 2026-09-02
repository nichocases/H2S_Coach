import 'package:flutter/material.dart';

const _brandSeed = Color(0xFF0F766E);

ThemeData buildLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _brandSeed),
    useMaterial3: true,
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _brandSeed,
    ),
    useMaterial3: true,
  );
}
