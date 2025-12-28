import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/notification_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _classRemindersEnabled = true;
  bool _newsAlertsEnabled = true;
  bool _examModeEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _classRemindersEnabled = prefs.getBool('class_reminders_enabled') ?? true;
      _newsAlertsEnabled = prefs.getBool('news_alerts_enabled') ?? true;
      _examModeEnabled = prefs.getBool('exam_mode_enabled') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleClassReminders(bool value) async {
    setState(() => _classRemindersEnabled = value);
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('class_reminders_enabled', value);

    if (value) {
      // User enabled → Schedule all class alerts from timetable
      await NotificationService.scheduleTimetable();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Class alerts enabled'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // User disabled → Cancel all class alerts
      await NotificationService.cancelAllClassAlerts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔕 Class alerts disabled'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOTIFICATION CHANNELS HEADER
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Notification Channels',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // CHANNEL 1: CLASS ALERTS (Battery Saver)
                        _buildSectionCard(
                          context,
                          'Class Reminders',
                          [
                            SwitchListTile(
                              title: Text(
                                'Class Alerts',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Get alerts 10 min & 5 min before every class\nHigh frequency - Can be disabled to save battery',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              secondary: Icon(
                                Icons.access_time,
                                color: _classRemindersEnabled ? Colors.amber : Colors.grey,
                                size: 32,
                              ),
                              value: _classRemindersEnabled,
                              activeColor: Colors.amber,
                              onChanged: _toggleClassReminders,
                            ),
                            if (_classRemindersEnabled)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Notifications use battery-optimized scheduling. Disable to save battery if not needed.',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // CHANNEL 2: NEWS & UPDATES (Critical)
                        _buildSectionCard(
                          context,
                          'College News & Updates',
                          [
                            SwitchListTile(
                              title: Text(
                                'News Alerts',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Exam schedules, events, holidays, and important announcements\nLow frequency - Recommended to keep enabled',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              secondary: Icon(
                                Icons.newspaper,
                                color: _newsAlertsEnabled ? Colors.cyanAccent : Colors.grey,
                                size: 32,
                              ),
                              value: _newsAlertsEnabled,
                              activeColor: Colors.cyanAccent,
                              onChanged: (bool value) async {
                                setState(() => _newsAlertsEnabled = value);
                                
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('news_alerts_enabled', value);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      value 
                                        ? '✅ News alerts enabled' 
                                        : '🔕 News alerts disabled',
                                    ),
                                    backgroundColor: value ? Colors.green : Colors.orange,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            if (_newsAlertsEnabled)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.cyan.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.cyanAccent, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Recommended: Keep enabled to stay updated on important college announcements.',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.cyanAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                        
                        const SizedBox(height: 16),
                        
                        // EXAM MODE SECTION (NEW)
                        _buildSectionCard(
                          context,
                          'Exam / Silent Mode',
                          [
                            SwitchListTile(
                              title: Text(
                                'Exam Mode',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Suppress all class alarms temporarily\nPerfect for exams and important meetings',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              secondary: Icon(
                                Icons.school,
                                color: _examModeEnabled ? Colors.orange : Colors.grey,
                                size: 32,
                              ),
                              value: _examModeEnabled,
                              activeColor: Colors.orange,
                              onChanged: (bool value) async {
                                setState(() => _examModeEnabled = value);
                                
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('exam_mode_enabled', value);

                                if (value) {
                                  // 🛑 TURN ON SILENT MODE: Cancel everything immediately
                                  await NotificationService.cancelAllClassAlerts();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Exam Mode ON. All alarms silenced. 🤫'),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // ✅ TURN OFF SILENT MODE: Re-schedule everything
                                  await NotificationService.scheduleTimetable();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Exam Mode OFF. Alarms restored. ✅'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (_examModeEnabled)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orange.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'All class notifications are currently silenced. Turn off Exam Mode to restore them.',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.orange,
                                          ),
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