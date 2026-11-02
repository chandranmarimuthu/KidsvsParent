import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF203738);
  static const teal = Color(0xFF17766E);
  static const deepTeal = Color(0xFF125D58);
  static const coral = Color(0xFFE56D58);
  static const marigold = Color(0xFFFFC857);
  static const lilac = Color(0xFF8793C8);
  static const mint = Color(0xFFDCEFE4);
  static const paper = Color(0xFFFAF8F1);
  static const line = Color(0xFFE4E6DD);
  static const muted = Color(0xFF687775);
}

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal, primary: AppColors.teal, secondary: AppColors.coral, tertiary: AppColors.marigold, surface: AppColors.paper),
    scaffoldBackgroundColor: AppColors.paper,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.paper, foregroundColor: AppColors.ink, elevation: 0, scrolledUnderElevation: 0, titleTextStyle: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w700)),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.paper,
      indicatorColor: AppColors.mint,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? AppColors.deepTeal : AppColors.muted);
      }),
    ),
    cardTheme: const CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)), side: BorderSide(color: AppColors.line))),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.teal, width: 1.5)),
    ),
  );
}