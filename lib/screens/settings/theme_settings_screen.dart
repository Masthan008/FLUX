import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../theme/app_theme.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AccessibilityProvider>(
      builder: (context, themeProvider, accessibilityProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Theme Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  accessibilityProvider.provideFeedback(text: 'Going back');
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dark/Light Mode Toggle
                  _buildSectionCard(
                    context,
                    'Appearance Mode',
                    [
                      SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleDarkMode();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Dark mode enabled' : 'Light mode enabled',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Theme Selection
                  _buildSectionCard(
                    context,
                    'Theme Colors',
                    [
                      ...themeProvider.availableThemes.keys.map((themeName) {
                        return RadioListTile<String>(
                          title: Text(
                            _getThemeDisplayName(themeName),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: _buildThemePreview(themeProvider.availableThemes[themeName]!),
                          value: themeName,
                          groupValue: themeProvider.selectedTheme,
                          onChanged: (value) {
                            if (value != null) {
                              themeProvider.setTheme(value);
                              accessibilityProvider.provideFeedback(
                                text: '${_getThemeDisplayName(value)} theme selected',
                              );
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Custom Colors (only show if custom theme is selected)
                  if (themeProvider.selectedTheme == 'custom')
                    _buildSectionCard(
                      context,
                      'Custom Colors',
                      [
                        ListTile(
                          title: Text(
                            'Primary Color',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: themeProvider.getCurrentPrimaryColor(),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          onTap: () => _showColorPicker(
                            context,
                            'Primary Color',
                            themeProvider.getCurrentPrimaryColor(),
                            (color) {
                              themeProvider.setCustomColors(
                                '#${color.value.toRadixString(16).substring(2)}',
                                themeProvider.customSecondaryColor,
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Secondary Color',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: themeProvider.getCurrentSecondaryColor(),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          onTap: () => _showColorPicker(
                            context,
                            'Secondary Color',
                            themeProvider.getCurrentSecondaryColor(),
                            (color) {
                              themeProvider.setCustomColors(
                                themeProvider.customPrimaryColor,
                                '#${color.value.toRadixString(16).substring(2)}',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Font Settings
                  _buildSectionCard(
                    context,
                    'Typography',
                    [
                      ListTile(
                        title: Text(
                          'Font Family',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          themeProvider.fontFamily,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showFontSelector(context, themeProvider, accessibilityProvider),
                      ),
                      ListTile(
                        title: Text(
                          'Font Size',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${themeProvider.fontSize.toInt()}px',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Slider(
                              value: themeProvider.fontSize,
                              min: 12.0,
                              max: 24.0,
                              divisions: 12,
                              onChanged: (value) {
                                themeProvider.setFontSize(value);
                              },
                              onChangeEnd: (value) {
                                accessibilityProvider.provideFeedback(
                                  text: 'Font size set to ${value.toInt()} pixels',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // High Contrast Mode
                  _buildSectionCard(
                    context,
                    'Accessibility',
                    [
                      SwitchListTile(
                        title: Text(
                          'High Contrast Mode',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Improves readability with high contrast colors',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: themeProvider.isHighContrast,
                        onChanged: (value) {
                          themeProvider.toggleHighContrast();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'High contrast mode enabled' : 'High contrast mode disabled',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemePreview(Map<String, Color> colors) {
    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: colors.values.take(4).map((color) {
          return Expanded(
            child: Container(
              color: color,
              margin: const EdgeInsets.only(right: 2),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getThemeDisplayName(String themeName) {
    switch (themeName) {
      case 'default':
        return 'Default (Midnight)';
      case 'ocean':
        return 'Ocean Blue';
      case 'forest':
        return 'Forest Green';
      case 'sunset':
        return 'Sunset Purple';
      case 'custom':
        return 'Custom Colors';
      default:
        return themeName;
    }
  }

  void _showColorPicker(
    BuildContext context,
    String title,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: Colors.primaries.length,
            itemBuilder: (context, index) {
              final color = Colors.primaries[index];
              return GestureDetector(
                onTap: () {
                  onColorChanged(color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: currentColor == color
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFontSelector(
    BuildContext context,
    ThemeProvider themeProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Font Family'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView.builder(
            itemCount: themeProvider.availableFonts.length,
            itemBuilder: (context, index) {
              final font = themeProvider.availableFonts[index];
              return ListTile(
                title: Text(
                  font,
                  style: TextStyle(fontFamily: font),
                ),
                trailing: themeProvider.fontFamily == font
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  themeProvider.setFontFamily(font);
                  accessibilityProvider.provideFeedback(text: '$font font selected');
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}