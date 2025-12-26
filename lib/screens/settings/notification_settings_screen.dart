import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../providers/theme_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<NotificationProvider, AccessibilityProvider, ThemeProvider>(
      builder: (context, notificationProvider, accessibilityProvider, themeProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Notification Settings',
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
                  // General Notification Settings
                  _buildSectionCard(
                    context,
                    'General Settings',
                    [
                      SwitchListTile(
                        title: Text(
                          'Enable Notifications',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Allow the app to send notifications',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: notificationProvider.notificationsEnabled,
                        onChanged: (value) {
                          notificationProvider.toggleNotifications();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Notifications enabled' : 'Notifications disabled',
                          );
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Sound',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Play sound for notifications',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: notificationProvider.soundEnabled,
                        onChanged: notificationProvider.notificationsEnabled
                            ? (value) {
                                notificationProvider.toggleSound();
                                accessibilityProvider.provideFeedback(
                                  text: value ? 'Notification sounds enabled' : 'Notification sounds disabled',
                                );
                              }
                            : null,
                      ),
                      SwitchListTile(
                        title: Text(
                          'Vibration',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Vibrate for notifications',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: notificationProvider.vibrationEnabled,
                        onChanged: notificationProvider.notificationsEnabled
                            ? (value) {
                                notificationProvider.toggleVibration();
                                accessibilityProvider.provideFeedback(
                                  text: value ? 'Notification vibration enabled' : 'Notification vibration disabled',
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Sound Settings
                  if (notificationProvider.soundEnabled && notificationProvider.notificationsEnabled)
                    _buildSectionCard(
                      context,
                      'Sound Settings',
                      [
                        ListTile(
                          title: Text(
                            'Volume',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(notificationProvider.volume * 100).toInt()}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                value: notificationProvider.volume,
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                onChanged: (value) {
                                  notificationProvider.setVolume(value);
                                },
                                onChangeEnd: (value) {
                                  notificationProvider.playNotificationSound();
                                  accessibilityProvider.provideFeedback(
                                    text: 'Volume set to ${(value * 100).toInt()} percent',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Notification Sound',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            notificationProvider.selectedSound.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _showSoundSelector(
                            context,
                            notificationProvider,
                            accessibilityProvider,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Sound Previews
                  if (notificationProvider.soundEnabled && notificationProvider.notificationsEnabled)
                    _buildSectionCard(
                      context,
                      'Sound Previews',
                      [
                        Text(
                          'Test different notification sounds',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        ...notificationProvider.availableSounds.map((sound) {
                          final isSelected = sound.id == notificationProvider.selectedSoundId;
                          return ListTile(
                            leading: Icon(
                              sound.icon,
                              color: isSelected ? Theme.of(context).primaryColor : null,
                            ),
                            title: Text(
                              sound.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: isSelected ? Theme.of(context).primaryColor : null,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    notificationProvider.previewSound(sound.id);
                                    accessibilityProvider.provideFeedback(
                                      text: 'Playing ${sound.name} sound',
                                    );
                                  },
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, color: Colors.green),
                              ],
                            ),
                            onTap: () {
                              notificationProvider.setNotificationSound(sound.id);
                              notificationProvider.previewSound(sound.id);
                              accessibilityProvider.provideFeedback(
                                text: '${sound.name} sound selected',
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Test Section
                  _buildSectionCard(
                    context,
                    'Test Notifications',
                    [
                      Text(
                        'Test different types of notifications',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: notificationProvider.notificationsEnabled
                                  ? () {
                                      notificationProvider.showSuccessNotification();
                                      accessibilityProvider.provideFeedback(
                                        text: 'Success notification test',
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Success'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: notificationProvider.notificationsEnabled
                                  ? () {
                                      notificationProvider.showErrorNotification();
                                      accessibilityProvider.provideFeedback(
                                        text: 'Error notification test',
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.error),
                              label: const Text('Error'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: notificationProvider.notificationsEnabled
                                  ? () {
                                      notificationProvider.showAlertNotification();
                                      accessibilityProvider.provideFeedback(
                                        text: 'Alert notification test',
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.warning),
                              label: const Text('Alert'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: notificationProvider.notificationsEnabled
                                  ? () {
                                      notificationProvider.showGentleNotification();
                                      accessibilityProvider.provideFeedback(
                                        text: 'Gentle notification test',
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.notifications_none),
                              label: const Text('Gentle'),
                            ),
                          ),
                        ],
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

  void _showSoundSelector(
    BuildContext context,
    NotificationProvider notificationProvider,
    AccessibilityProvider accessibilityProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Notification Sound'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView.builder(
            itemCount: notificationProvider.availableSounds.length,
            itemBuilder: (context, index) {
              final sound = notificationProvider.availableSounds[index];
              final isSelected = sound.id == notificationProvider.selectedSoundId;
              
              return ListTile(
                leading: Icon(sound.icon),
                title: Text(sound.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => notificationProvider.previewSound(sound.id),
                    ),
                    if (isSelected)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
                onTap: () {
                  notificationProvider.setNotificationSound(sound.id);
                  notificationProvider.previewSound(sound.id);
                  accessibilityProvider.provideFeedback(text: '${sound.name} selected');
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