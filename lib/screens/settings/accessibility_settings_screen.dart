import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../providers/theme_provider.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccessibilityProvider, ThemeProvider>(
      builder: (context, accessibilityProvider, themeProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Accessibility Settings',
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
                  // Screen Reader Settings
                  _buildSectionCard(
                    context,
                    'Screen Reader',
                    [
                      SwitchListTile(
                        title: Text(
                          'Enable Screen Reader',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Reads screen content aloud',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: accessibilityProvider.screenReaderEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleScreenReader();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Screen reader enabled' : 'Screen reader disabled',
                          );
                        },
                      ),
                      if (accessibilityProvider.screenReaderEnabled) ...[
                        ListTile(
                          title: Text(
                            'Speech Rate',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(accessibilityProvider.speechRate * 100).toInt()}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                value: accessibilityProvider.speechRate,
                                min: 0.1,
                                max: 1.0,
                                divisions: 9,
                                onChanged: (value) {
                                  accessibilityProvider.setSpeechRate(value);
                                },
                                onChangeEnd: (value) {
                                  accessibilityProvider.speak('Speech rate set to ${(value * 100).toInt()} percent');
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Speech Pitch',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(accessibilityProvider.speechPitch * 100).toInt()}%',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                value: accessibilityProvider.speechPitch,
                                min: 0.5,
                                max: 2.0,
                                divisions: 15,
                                onChanged: (value) {
                                  accessibilityProvider.setSpeechPitch(value);
                                },
                                onChangeEnd: (value) {
                                  accessibilityProvider.speak('Speech pitch set to ${(value * 100).toInt()} percent');
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Test Speech',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            'Tap to test current speech settings',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: accessibilityProvider.isSpeaking
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.play_arrow),
                          onTap: () {
                            if (accessibilityProvider.isSpeaking) {
                              accessibilityProvider.stopSpeaking();
                            } else {
                              accessibilityProvider.speak(
                                'This is a test of the screen reader functionality. The speech rate and pitch can be adjusted to your preference.',
                              );
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Voice Commands
                  _buildSectionCard(
                    context,
                    'Voice Commands',
                    [
                      SwitchListTile(
                        title: Text(
                          'Enable Voice Commands',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Control the app with voice commands',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: accessibilityProvider.voiceCommandsEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleVoiceCommands();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Voice commands enabled' : 'Voice commands disabled',
                          );
                        },
                      ),
                      if (accessibilityProvider.voiceCommandsEnabled) ...[
                        ListTile(
                          title: Text(
                            'Voice Listening',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            accessibilityProvider.isListening 
                                ? 'Listening for commands...' 
                                : 'Tap to start listening',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: accessibilityProvider.isListening
                              ? const Icon(Icons.mic, color: Colors.red)
                              : const Icon(Icons.mic_none),
                          onTap: () {
                            if (accessibilityProvider.isListening) {
                              accessibilityProvider.stopListening();
                            } else {
                              accessibilityProvider.startListening();
                            }
                          },
                        ),
                        if (accessibilityProvider.lastWords.isNotEmpty)
                          ListTile(
                            title: Text(
                              'Last Command',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              accessibilityProvider.lastWords,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ListTile(
                          title: Text(
                            'Available Commands',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: const Text(
                            '• "go back" - Navigate back\n'
                            '• "open calculator" - Open calculator\n'
                            '• "set alarm" - Open alarm screen\n'
                            '• "show roadmaps" - Open roadmaps\n'
                            '• "start focus" - Open focus forest',
                          ),
                          trailing: const Icon(Icons.help_outline),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Gesture Controls
                  _buildSectionCard(
                    context,
                    'Gesture Controls',
                    [
                      SwitchListTile(
                        title: Text(
                          'Enable Gesture Controls',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Navigate with swipe gestures',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: accessibilityProvider.gestureControlsEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleGestureControls();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Gesture controls enabled' : 'Gesture controls disabled',
                          );
                        },
                      ),
                      if (accessibilityProvider.gestureControlsEnabled)
                        ListTile(
                          title: Text(
                            'Gesture Guide',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: const Text(
                            '• Swipe right - Go back\n'
                            '• Swipe left - Open drawer\n'
                            '• Double tap - Select item\n'
                            '• Long press - Show options',
                          ),
                          trailing: const Icon(Icons.touch_app),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Other Accessibility Options
                  _buildSectionCard(
                    context,
                    'Other Options',
                    [
                      SwitchListTile(
                        title: Text(
                          'Haptic Feedback',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Vibration feedback for interactions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: accessibilityProvider.hapticFeedbackEnabled,
                        onChanged: (value) {
                          accessibilityProvider.toggleHapticFeedback();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Haptic feedback enabled' : 'Haptic feedback disabled',
                            haptic: value,
                          );
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Reduce Animations',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Reduces motion for better accessibility',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: accessibilityProvider.reduceAnimations,
                        onChanged: (value) {
                          accessibilityProvider.toggleReduceAnimations();
                          accessibilityProvider.provideFeedback(
                            text: value ? 'Animations reduced' : 'Normal animations enabled',
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
}