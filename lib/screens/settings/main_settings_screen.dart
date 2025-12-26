import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/accessibility_provider.dart';
import 'theme_settings_screen.dart';
import 'accessibility_settings_screen.dart';
import 'dashboard_settings_screen.dart';
import 'notification_settings_screen.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

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
                'Settings',
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
                  // User Experience Section
                  _buildSectionCard(
                    context,
                    'User Experience',
                    [
                      _buildSettingsTile(
                        context,
                        'Theme & Appearance',
                        'Customize colors, fonts, and visual style',
                        Icons.palette,
                        () {
                          accessibilityProvider.provideFeedback(text: 'Opening theme settings');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThemeSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        'Dashboard Layout',
                        'Personalize your dashboard and app arrangement',
                        Icons.dashboard,
                        () {
                          accessibilityProvider.provideFeedback(text: 'Opening dashboard settings');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        context,
                        'Notifications & Sounds',
                        'Configure notification sounds and preferences',
                        Icons.notifications,
                        () {
                          accessibilityProvider.provideFeedback(text: 'Opening notification settings');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationSettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Accessibility Section
                  _buildSectionCard(
                    context,
                    'Accessibility',
                    [
                      _buildSettingsTile(
                        context,
                        'Accessibility Features',
                        'Screen reader, voice commands, and gesture controls',
                        Icons.accessibility,
                        () {
                          accessibilityProvider.provideFeedback(text: 'Opening accessibility settings');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccessibilitySettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Accessibility Toggles (Voice features only)
                  _buildSectionCard(
                    context,
                    'Quick Accessibility',
                    [
                      SwitchListTile(
                        title: Text(
                          'Screen Reader',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Read screen content aloud',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        secondary: const Icon(Icons.record_voice_over),
                        value: accessibilityProvider.screenReaderEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleScreenReader();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Screen reader enabled' : 'Screen reader disabled',
                          );
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Voice Commands',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Control app with voice commands',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        secondary: const Icon(Icons.mic),
                        value: accessibilityProvider.voiceCommandsEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleVoiceCommands();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Voice commands enabled' : 'Voice commands disabled',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Current Theme Preview
                  _buildSectionCard(
                    context,
                    'Current Theme Preview',
                    [
                      Container(
                        height: 100,
                        decoration: themeProvider.getCurrentBackgroundDecoration(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'FluxFlow',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Theme: ${_getThemeDisplayName(themeProvider.selectedTheme)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  String _getThemeDisplayName(String themeName) {
    switch (themeName) {
      case 'default':
        return 'Default';
      case 'ocean':
        return 'Ocean Blue';
      case 'forest':
        return 'Forest Green';
      case 'sunset':
        return 'Sunset Purple';
      case 'custom':
        return 'Custom';
      default:
        return themeName;
    }
  }
}