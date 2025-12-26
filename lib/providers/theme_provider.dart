import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxKey = 'theme_settings';
  late Box _themeBox;
  
  // Theme Settings
  bool _isDarkMode = true;
  String _selectedTheme = 'default';
  double _fontSize = 16.0;
  bool _isHighContrast = false;
  String _customPrimaryColor = '#4B0082';
  String _customSecondaryColor = '#191970';
  String _fontFamily = 'Roboto';
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  String get selectedTheme => _selectedTheme;
  double get fontSize => _fontSize;
  bool get isHighContrast => _isHighContrast;
  String get customPrimaryColor => _customPrimaryColor;
  String get customSecondaryColor => _customSecondaryColor;
  String get fontFamily => _fontFamily;

  // Available themes
  final Map<String, Map<String, Color>> availableThemes = {
    'default': {
      'primary': const Color(0xFF4B0082),
      'secondary': const Color(0xFF191970),
      'background1': const Color(0xFF191970),
      'background2': const Color(0xFF2E004F),
      'background3': const Color(0xFF4B0082),
      'background4': const Color(0xFF000033),
    },
    'ocean': {
      'primary': const Color(0xFF006994),
      'secondary': const Color(0xFF004D6B),
      'background1': const Color(0xFF001F3F),
      'background2': const Color(0xFF003366),
      'background3': const Color(0xFF006994),
      'background4': const Color(0xFF001122),
    },
    'forest': {
      'primary': const Color(0xFF2E7D32),
      'secondary': const Color(0xFF1B5E20),
      'background1': const Color(0xFF0D2818),
      'background2': const Color(0xFF1B4332),
      'background3': const Color(0xFF2E7D32),
      'background4': const Color(0xFF081C15),
    },
    'sunset': {
      'primary': const Color(0xFFFF6B35),
      'secondary': const Color(0xFFE63946),
      'background1': const Color(0xFF2D1B69),
      'background2': const Color(0xFF5A189A),
      'background3': const Color(0xFF9D4EDD),
      'background4': const Color(0xFF240046),
    },
    'custom': {
      'primary': const Color(0xFF4B0082),
      'secondary': const Color(0xFF191970),
      'background1': const Color(0xFF191970),
      'background2': const Color(0xFF2E004F),
      'background3': const Color(0xFF4B0082),
      'background4': const Color(0xFF000033),
    },
  };

  // Font families
  final List<String> availableFonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Source Sans Pro',
    'Poppins',
    'Nunito',
    'Raleway',
  ];

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    try {
      _themeBox = await Hive.openBox(_themeBoxKey);
      _loadThemeSettings();
    } catch (e) {
      debugPrint('Error initializing theme: $e');
    }
  }

  void _loadThemeSettings() {
    _isDarkMode = _themeBox.get('isDarkMode', defaultValue: true);
    _selectedTheme = _themeBox.get('selectedTheme', defaultValue: 'default');
    _fontSize = _themeBox.get('fontSize', defaultValue: 16.0);
    _isHighContrast = _themeBox.get('isHighContrast', defaultValue: false);
    _customPrimaryColor = _themeBox.get('customPrimaryColor', defaultValue: '#4B0082');
    _customSecondaryColor = _themeBox.get('customSecondaryColor', defaultValue: '#191970');
    _fontFamily = _themeBox.get('fontFamily', defaultValue: 'Roboto');
    notifyListeners();
  }

  Future<void> _saveThemeSettings() async {
    try {
      await _themeBox.put('isDarkMode', _isDarkMode);
      await _themeBox.put('selectedTheme', _selectedTheme);
      await _themeBox.put('fontSize', _fontSize);
      await _themeBox.put('isHighContrast', _isHighContrast);
      await _themeBox.put('customPrimaryColor', _customPrimaryColor);
      await _themeBox.put('customSecondaryColor', _customSecondaryColor);
      await _themeBox.put('fontFamily', _fontFamily);
    } catch (e) {
      debugPrint('Error saving theme settings: $e');
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveThemeSettings();
    notifyListeners();
  }

  void setThemeMode(bool isDark) {
    _isDarkMode = isDark;
    _saveThemeSettings();
    notifyListeners();
  }

  void setTheme(String theme) {
    _selectedTheme = theme;
    _saveThemeSettings();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size.clamp(12.0, 24.0);
    _saveThemeSettings();
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    _saveThemeSettings();
    notifyListeners();
  }

  void setCustomColors(String primary, String secondary) {
    _customPrimaryColor = primary;
    _customSecondaryColor = secondary;
    if (_selectedTheme == 'custom') {
      availableThemes['custom']!['primary'] = Color(int.parse(primary.replaceAll('#', '0xFF')));
      availableThemes['custom']!['secondary'] = Color(int.parse(secondary.replaceAll('#', '0xFF')));
    }
    _saveThemeSettings();
    notifyListeners();
  }

  void setFontFamily(String font) {
    _fontFamily = font;
    _saveThemeSettings();
    notifyListeners();
  }

  Color getCurrentPrimaryColor() {
    if (_selectedTheme == 'custom') {
      return Color(int.parse(_customPrimaryColor.replaceAll('#', '0xFF')));
    }
    return availableThemes[_selectedTheme]!['primary']!;
  }

  Color getCurrentSecondaryColor() {
    if (_selectedTheme == 'custom') {
      return Color(int.parse(_customSecondaryColor.replaceAll('#', '0xFF')));
    }
    return availableThemes[_selectedTheme]!['secondary']!;
  }

  List<Color> getCurrentGradientColors() {
    final theme = availableThemes[_selectedTheme]!;
    return [
      theme['background1']!,
      theme['background2']!,
      theme['background3']!,
      theme['background4']!,
    ];
  }

  ThemeData getCurrentTheme() {
    final primaryColor = getCurrentPrimaryColor();
    final secondaryColor = getCurrentSecondaryColor();
    
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: primaryColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black87,
          fontFamily: _fontFamily,
          fontSize: _fontSize,
        ),
        bodyMedium: TextStyle(
          color: _isDarkMode ? Colors.white70 : Colors.black54,
          fontFamily: _fontFamily,
          fontSize: _fontSize - 2,
        ),
        displayLarge: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
          fontSize: _fontSize + 8,
        ),
        headlineMedium: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
          fontSize: _fontSize + 4,
        ),
        titleLarge: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
          fontSize: _fontSize + 2,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.transparent,
      ).copyWith(
        // High contrast adjustments
        primary: _isHighContrast ? (_isDarkMode ? Colors.white : Colors.black) : primaryColor,
        onPrimary: _isHighContrast ? (_isDarkMode ? Colors.black : Colors.white) : null,
      ),
      useMaterial3: true,
    );
  }

  BoxDecoration getCurrentBackgroundDecoration() {
    if (_isHighContrast) {
      return BoxDecoration(
        color: _isDarkMode ? Colors.black : Colors.white,
      );
    }
    
    final gradientColors = getCurrentGradientColors();
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
    );
  }
}