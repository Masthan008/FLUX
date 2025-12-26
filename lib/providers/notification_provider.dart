import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationSound {
  final String id;
  final String name;
  final String assetPath;
  final IconData icon;

  NotificationSound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'assetPath': assetPath,
      'iconCodePoint': icon.codePoint,
    };
  }

  factory NotificationSound.fromMap(Map<String, dynamic> map) {
    return NotificationSound(
      id: map['id'],
      name: map['name'],
      assetPath: map['assetPath'],
      icon: _getIconFromCodePoint(map['iconCodePoint']),
    );
  }

  static IconData _getIconFromCodePoint(int? codePoint) {
    // Map common codePoints to their corresponding Icons constants
    switch (codePoint) {
      case 0xe7f4: return Icons.notifications;
      case 0xe405: return Icons.music_note;
      case 0xe7f7: return Icons.notifications_active;
      case 0xe0c9: return Icons.circle_notifications;
      case 0xe7f5: return Icons.notifications_none;
      case 0xe002: return Icons.warning;
      case 0xe86c: return Icons.check_circle;
      case 0xe000: return Icons.error;
      default: return Icons.notifications; // Default fallback icon
    }
  }
}

class NotificationProvider extends ChangeNotifier {
  static const String _notificationBoxKey = 'notification_settings';
  late Box _notificationBox;
  late AudioPlayer _audioPlayer;
  
  // Notification Settings
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  double _volume = 0.7;
  String _selectedSoundId = 'default';
  
  // Available notification sounds (using existing alarm sounds)
  final List<NotificationSound> _availableSounds = [
    NotificationSound(
      id: 'default',
      name: 'Default',
      assetPath: 'sounds/alarm_1.mp3',
      icon: Icons.notifications,
    ),
    NotificationSound(
      id: 'chime',
      name: 'Chime',
      assetPath: 'sounds/alarm_2.mp3',
      icon: Icons.music_note,
    ),
    NotificationSound(
      id: 'bell',
      name: 'Bell',
      assetPath: 'sounds/alarm_3.mp3',
      icon: Icons.notifications_active,
    ),
    NotificationSound(
      id: 'ping',
      name: 'Ping',
      assetPath: 'sounds/alarm_4.mp3',
      icon: Icons.circle_notifications,
    ),
    NotificationSound(
      id: 'gentle',
      name: 'Gentle',
      assetPath: 'sounds/alarm_5.mp3',
      icon: Icons.notifications_none,
    ),
    NotificationSound(
      id: 'alert',
      name: 'Alert',
      assetPath: 'sounds/alarm_6.mp3',
      icon: Icons.warning,
    ),
    NotificationSound(
      id: 'success',
      name: 'Success',
      assetPath: 'sounds/alarm_7.mp3',
      icon: Icons.check_circle,
    ),
    NotificationSound(
      id: 'error',
      name: 'Error',
      assetPath: 'sounds/alarm_8.mp3',
      icon: Icons.error,
    ),
  ];
  
  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  double get volume => _volume;
  String get selectedSoundId => _selectedSoundId;
  List<NotificationSound> get availableSounds => _availableSounds;
  
  NotificationSound get selectedSound => 
      _availableSounds.firstWhere((sound) => sound.id == _selectedSoundId);

  NotificationProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      _notificationBox = await Hive.openBox(_notificationBoxKey);
      _audioPlayer = AudioPlayer();
      _loadNotificationSettings();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  void _loadNotificationSettings() {
    _notificationsEnabled = _notificationBox.get('notificationsEnabled', defaultValue: true);
    _soundEnabled = _notificationBox.get('soundEnabled', defaultValue: true);
    _vibrationEnabled = _notificationBox.get('vibrationEnabled', defaultValue: true);
    _volume = _notificationBox.get('volume', defaultValue: 0.7);
    _selectedSoundId = _notificationBox.get('selectedSoundId', defaultValue: 'default');
    notifyListeners();
  }

  Future<void> _saveNotificationSettings() async {
    try {
      await _notificationBox.put('notificationsEnabled', _notificationsEnabled);
      await _notificationBox.put('soundEnabled', _soundEnabled);
      await _notificationBox.put('vibrationEnabled', _vibrationEnabled);
      await _notificationBox.put('volume', _volume);
      await _notificationBox.put('selectedSoundId', _selectedSoundId);
    } catch (e) {
      debugPrint('Error saving notification settings: $e');
    }
  }

  // Settings Management
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    _saveNotificationSettings();
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _saveNotificationSettings();
    notifyListeners();
  }

  void toggleVibration() {
    _vibrationEnabled = !_vibrationEnabled;
    _saveNotificationSettings();
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _saveNotificationSettings();
    notifyListeners();
  }

  void setNotificationSound(String soundId) {
    _selectedSoundId = soundId;
    _saveNotificationSettings();
    notifyListeners();
  }

  // Sound Playback
  Future<void> playNotificationSound({String? soundId}) async {
    if (!_soundEnabled || !_notificationsEnabled) return;
    
    try {
      final sound = soundId != null 
          ? _availableSounds.firstWhere((s) => s.id == soundId)
          : selectedSound;
      
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(AssetSource(sound.assetPath));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
      // Fallback to system sound
      SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> previewSound(String soundId) async {
    try {
      final sound = _availableSounds.firstWhere((s) => s.id == soundId);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(AssetSource(sound.assetPath));
    } catch (e) {
      debugPrint('Error previewing sound: $e');
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Vibration
  Future<void> triggerVibration({int duration = 100}) async {
    if (!_vibrationEnabled || !_notificationsEnabled) return;
    
    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error triggering vibration: $e');
    }
  }

  // Combined Notification
  Future<void> showNotification({
    String? soundId,
    bool vibrate = true,
    int vibrationDuration = 100,
  }) async {
    if (!_notificationsEnabled) return;
    
    // Play sound
    if (_soundEnabled) {
      await playNotificationSound(soundId: soundId);
    }
    
    // Trigger vibration
    if (_vibrationEnabled && vibrate) {
      await triggerVibration(duration: vibrationDuration);
    }
  }

  // Specific notification types
  Future<void> showSuccessNotification() async {
    await showNotification(soundId: 'success');
  }

  Future<void> showErrorNotification() async {
    await showNotification(soundId: 'error', vibrationDuration: 200);
  }

  Future<void> showAlertNotification() async {
    await showNotification(soundId: 'alert', vibrationDuration: 150);
  }

  Future<void> showGentleNotification() async {
    await showNotification(soundId: 'gentle', vibrationDuration: 50);
  }

  // Cleanup
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}