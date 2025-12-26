import 'package:flutter/material.dart';
import 'app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // static final _fontFamily = GoogleFonts.cairo().fontFamily;
  static final _fontFamily = null; // Use system font for simplicity

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimaryForeground,
      secondary: AppColors.lightPrimary,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightForeground,
      background: AppColors.lightBackground,
      onBackground: AppColors.lightForeground,
      error: AppColors.lightDestructive,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.lightForeground,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: AppColors.lightForeground,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: AppColors.lightForeground,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(color: AppColors.lightForeground, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.lightMutedForeground, fontSize: 12),
      labelLarge: TextStyle(
        color: AppColors.lightPrimaryForeground,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightCard,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.lightForeground),
      titleTextStyle: TextStyle(
        color: AppColors.lightPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 0.625rem
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryForeground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightForeground,
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightCard,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightMutedForeground,
      elevation: 2,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkPrimaryForeground,
      secondary: AppColors.darkPrimary,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkForeground,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkForeground,
      error: AppColors.darkDestructive,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.darkForeground,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: AppColors.darkForeground,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: AppColors.darkForeground,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(color: AppColors.darkForeground, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.darkMutedForeground, fontSize: 12),
      labelLarge: TextStyle(
        color: AppColors.darkPrimaryForeground,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkCard,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.darkForeground),
      titleTextStyle: TextStyle(
        color: AppColors.darkPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryForeground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkForeground,
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkMutedForeground,
      elevation: 2,
    ),
  );
}
