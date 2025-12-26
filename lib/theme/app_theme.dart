import 'package:flutter/material.dart';

class AppTheme {
  static const Color midnightBlue = Color(0xFF191970); // Deep Midnight Blue
  static const Color deepViolet = Color(0xFF4B0082); // Deep Violet
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.white70;

  // Enhanced theme with accessibility support
  static ThemeData createTheme({
    required bool isDarkMode,
    required Color primaryColor,
    required Color secondaryColor,
    required String fontFamily,
    required double fontSize,
    required bool isHighContrast,
    List<Color>? gradientColors,
  }) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final baseTextColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    
    // High contrast adjustments
    final effectivePrimaryColor = isHighContrast 
        ? (isDarkMode ? Colors.white : Colors.black)
        : primaryColor;
    
    final effectiveTextColor = isHighContrast
        ? (isDarkMode ? Colors.white : Colors.black)
        : baseTextColor;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: effectivePrimaryColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: effectiveTextColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
        ),
        bodyMedium: TextStyle(
          color: isHighContrast ? effectiveTextColor : secondaryTextColor,
          fontFamily: fontFamily,
          fontSize: fontSize - 2,
        ),
        displayLarge: TextStyle(
          color: effectiveTextColor,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
          fontSize: fontSize + 8,
        ),
        headlineMedium: TextStyle(
          color: effectiveTextColor,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          fontSize: fontSize + 4,
        ),
        titleLarge: TextStyle(
          color: effectiveTextColor,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          fontSize: fontSize + 2,
        ),
        labelLarge: TextStyle(
          color: effectiveTextColor,
          fontFamily: fontFamily,
          fontSize: fontSize - 1,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: effectivePrimaryColor,
        brightness: brightness,
        primary: effectivePrimaryColor,
        secondary: secondaryColor,
        surface: Colors.transparent,
      ).copyWith(
        onPrimary: isHighContrast 
            ? (isDarkMode ? Colors.black : Colors.white)
            : null,
      ),
      useMaterial3: true,
      // Enhanced button themes for accessibility
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
          minimumSize: const Size(88, 48), // Larger touch targets
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      iconTheme: IconThemeData(
        color: effectiveTextColor,
        size: fontSize + 8,
      ),
    );
  }

  // Legacy dark theme for backward compatibility
  static ThemeData get darkTheme {
    return createTheme(
      isDarkMode: true,
      primaryColor: deepViolet,
      secondaryColor: midnightBlue,
      fontFamily: 'Roboto',
      fontSize: 16.0,
      isHighContrast: false,
    );
  }

  // Enhanced background decoration with accessibility support
  static BoxDecoration createBackgroundDecoration({
    required bool isDarkMode,
    required bool isHighContrast,
    List<Color>? gradientColors,
  }) {
    if (isHighContrast) {
      return BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
      );
    }

    final colors = gradientColors ?? [
      midnightBlue,
      const Color(0xFF2E004F),
      deepViolet,
      const Color(0xFF000033),
    ];

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    );
  }

  // Legacy background decoration for backward compatibility
  static BoxDecoration get backgroundDecoration {
    return createBackgroundDecoration(
      isDarkMode: true,
      isHighContrast: false,
    );
  }

  // Predefined theme colors for quick selection
  static const Map<String, List<Color>> themeGradients = {
    'default': [
      Color(0xFF191970), // Midnight Blue
      Color(0xFF2E004F), // Darker Violet
      Color(0xFF4B0082), // Deep Violet
      Color(0xFF000033), // Almost Black Blue
    ],
    'ocean': [
      Color(0xFF001F3F), // Navy
      Color(0xFF003366), // Dark Blue
      Color(0xFF006994), // Ocean Blue
      Color(0xFF001122), // Deep Navy
    ],
    'forest': [
      Color(0xFF0D2818), // Dark Forest
      Color(0xFF1B4332), // Forest Green
      Color(0xFF2E7D32), // Green
      Color(0xFF081C15), // Deep Forest
    ],
    'sunset': [
      Color(0xFF2D1B69), // Deep Purple
      Color(0xFF5A189A), // Purple
      Color(0xFF9D4EDD), // Light Purple
      Color(0xFF240046), // Dark Purple
    ],
  };
}
