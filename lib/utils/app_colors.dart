import 'package:flutter/material.dart';

/// App color palette matching modern Material 3 and Quizzical Figma design.
class AppColors {
  // Primary Teal shades
  static const Color primary = Color(0xFF0E7A75);
  static const Color primaryLight = Color(0xFF2DD4BF);
  static const Color primaryDark = Color(0xFF0B5D59);
  static const Color primaryAccent = Color(0xFF14B8A6);

  // Background & Surface
  static const Color background = Color(0xFFF6F7F5);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF0F2F0);

  // Typography & Text
  static const Color textPrimary = Color(0xFF202735);
  static const Color textSecondary = Color(0xFF6D7480);
  static const Color textMuted = Color(0xFFA0A6AE);

  // Feedback Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // Pastel Category Colors
  static const List<Color> categoryPastels = [
    Color(0xFFC9D9FF), // Periwinkle
    Color(0xFFBDF5D0), // Mint
    Color(0xFFFFF5B8), // Lemon
    Color(0xFFE9B8F4), // Lilac
    Color(0xFFFFB9BD), // Coral
    Color(0xFFFAD9AE), // Apricot
    Color(0xFFB8E8EA), // Aqua
    Color(0xFFD9C7FF), // Lavender
    Color(0xFFC7E9B0), // Green
    Color(0xFFFFD2A6), // Peach
  ];

  static const List<Color> categoryIconColors = [
    Color(0xFF7C3AED),
    Color(0xFF16A34A),
    Color(0xFF0284C7),
    Color(0xFFD97706),
    Color(0xFFDB2777),
    Color(0xFF0D9488),
    Color(0xFFEA580C),
    Color(0xFF4F46E5),
    Color(0xFF9333EA),
    Color(0xFF65A30D),
  ];
}
