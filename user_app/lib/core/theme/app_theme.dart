import 'package:flutter/material.dart';
import '../utils/app_styles.dart'; // تأكد إن الفايل ده متعدل ومستخدم فيه .sp

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFD6EFD8),
    primaryColor: const Color(0xFF80AF81),
    hintColor: const Color(0xFF508D4E),
    canvasColor: const Color(0xFF80AF81),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF80AF81);
        }
        return const Color(0xFFCBCED4);
      }),
    ),
    iconTheme: const IconThemeData(color: Colors.black),

    // هنا بنستخدم الـ Styles اللي عملناها واللي المفروض تكون Responsive
    textTheme: TextTheme(
      displayLarge: AppStyles.styleBold30Primary,
      displayMedium: AppStyles.styleBold24Dark,
      displaySmall: AppStyles.styleSemiBold24Dark,

      headlineLarge: AppStyles.styleBold20Primary,
      headlineMedium: AppStyles.styleSemiBold20Dark,
      headlineSmall: AppStyles.styleSemiBold18Dark,

      titleLarge: AppStyles.styleMedium18Muted,
      titleMedium: AppStyles.styleMedium16Dark,
      titleSmall: AppStyles.styleMedium16Green,

      bodyLarge: AppStyles.styleMedium16Dark,
      bodyMedium: AppStyles.styleRegular16Muted,
      bodySmall: AppStyles.styleMedium14Dark,

      labelLarge: AppStyles.styleMedium14Primary,
      labelMedium: AppStyles.styleMedium12Dark,
      labelSmall: AppStyles.styleRegular12Muted,
    ),
  );

  // Dark Theme (التعديل المهم هنا)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Montserrat', // ده تمام عشان يبقى ديفولت
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    primaryColor: const Color(0xFF508D4E),
    hintColor: const Color(0xFF508D4E),
    canvasColor: const Color(0xFF2D2D2D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF2D2D2D),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF508D4E);
        }
        return Colors.grey;
      }),
    ),
    iconTheme: const IconThemeData(color: Colors.white),

    // بدل ما نكتب الستايل من جديد، بناخد الستايل الأصلي ونغير لونه بس
    textTheme: TextTheme(
      // Display
      displayLarge: AppStyles.styleBold30Primary.copyWith(color: Colors.white),
      displayMedium: AppStyles.styleBold24Dark.copyWith(color: Colors.white),
      displaySmall: AppStyles.styleSemiBold24Dark.copyWith(
        color: const Color(0xFFE5E5E5),
      ),

      // Headline
      headlineLarge: AppStyles.styleBold20Primary.copyWith(
        color: const Color(0xFF80AF81),
      ), // نفس اللون بس كتبته للتأكيد
      headlineMedium: AppStyles.styleSemiBold20Dark.copyWith(
        color: Colors.white,
      ),
      headlineSmall: AppStyles.styleSemiBold18Dark.copyWith(
        color: const Color(0xFFE5E5E5),
      ),

      // Title
      titleLarge: AppStyles.styleMedium18Muted.copyWith(
        color: const Color(0xFFD1D5DB),
      ),
      titleMedium: AppStyles.styleMedium16Dark.copyWith(color: Colors.white),
      titleSmall: AppStyles.styleMedium16Green.copyWith(
        color: const Color(0xFF16A34A),
      ),

      // Body
      bodyLarge: AppStyles.styleMedium16Dark.copyWith(color: Colors.white),
      bodyMedium: AppStyles.styleRegular16Muted.copyWith(
        color: const Color(0xFFD1D5DB),
      ),
      bodySmall: AppStyles.styleMedium14Dark.copyWith(color: Colors.white),

      // Label
      labelLarge: AppStyles.styleMedium14Primary.copyWith(
        color: const Color(0xFF80AF81),
      ),
      labelMedium: AppStyles.styleMedium12Dark.copyWith(color: Colors.white),
      labelSmall: AppStyles.styleRegular12Muted.copyWith(
        color: const Color(0xFFD1D5DB),
      ),
    ),
  );
}
