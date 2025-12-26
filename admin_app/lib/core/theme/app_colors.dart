import 'package:flutter/material.dart';

class AppColors {
  // Light Mode
  static const Color lightBackground = Color(0xFFD6EFD8);
  static const Color lightForeground = Color(0xFF1A1A1A);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF80AF81);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightMutedForeground = Color(0xFF4B5563);
  static const Color lightDestructive = Color(0xFFDC2626);

  // Dark Mode
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkForeground = Color(0xFFF1F5F9);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkPrimary = Color(0xFF508D4E);
  static const Color darkPrimaryForeground = Color(0xFFFFFFFF);
  static const Color darkMutedForeground = Color(0xFFCBD5E1);
  static const Color darkDestructive = Color(0xFFDC2626);

  // Neutral Colors from React code
  static const Color stockGreen = Color(0xFF16A34A); // text-green-600
  static const Color stockYellow = Color(0xFFD97706); // text-yellow-600

  // Status Colors
  static const Color pendingBG = Color(0xFFFEF9C3); // bg-yellow-100
  static const Color pendingFG = Color(0xFF854D0E); // text-yellow-800
  static const Color processingBG = Color(0xFFDBEAFE); // bg-blue-100
  static const Color processingFG = Color(0xFF1E40AF); // text-blue-800
  static const Color completedBG = Color(0xFFDCFCE7); // bg-green-100
  static const Color completedFG = Color(0xFF166534); // text-green-800
  static const Color cancelledBG = Color(0xFFFEE2E2); // bg-red-100
  static const Color cancelledFG = Color(0xFF991B1B); // text-red-800

  // Dark Status Colors
  static const Color darkPendingBG = Color(0xFF422006); // dark:bg-yellow-900
  static const Color darkPendingFG = Color(0xFFFDE047); // dark:text-yellow-200
  static const Color darkProcessingBG = Color(0xFF1E293B); // dark:bg-blue-900
  static const Color darkProcessingFG = Color(0xFF93C5FD); // dark:text-blue-200
  static const Color darkCompletedBG = Color(0xFF1A2E20); // dark:bg-green-900
  static const Color darkCompletedFG = Color(0xFF86EFAC); // dark:text-green-200
  static const Color darkCancelledBG = Color(0xFF450A0A); // dark:bg-red-900
  static const Color darkCancelledFG = Color(0xFFFCA5A5); // dark:text-red-200
}
