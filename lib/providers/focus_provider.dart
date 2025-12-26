import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

enum TreeStatus { none, seed, sprout, tree, dead }

class FocusProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool _isFocusing = false;
  int _timeLeft = 0;
  int _sessionDuration = 25 * 60; // 25 minutes (customizable)
  TreeStatus _treeStatus = TreeStatus.none;
  Timer? _timer;
  int _forestCount = 0;
  String _ambientSound = 'Silence';
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentStreak = 0;
  DateTime? _lastFocusDate;

  bool get isFocusing => _isFocusing;
  int get timeLeft => _timeLeft;
  TreeStatus get treeStatus => _treeStatus;
  int get forestCount => _forestCount;
  int get sessionDuration => _sessionDuration;
  String get ambientSound => _ambientSound;
  int get currentStreak => _currentStreak;

  void setSessionDuration(int minutes) {
    if (_isFocusing) return;
    _sessionDuration = minutes * 60;
    notifyListeners();
  }

  void setAmbientSound(String sound) {
    _ambientSound = sound;
    if (_isFocusing) {
      _playAmbientSound();
    }
    notifyListeners();
  }

  FocusProvider() {
    _loadUserData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // THE KILL SWITCH: If user leaves app while focusing, kill the tree
    if (state == AppLifecycleState.paused && _isFocusing) {
      _killTree();
    }
  }

  Future<void> _loadUserData() async {
    final box = await Hive.openBox('user_forest');
    _forestCount = box.get('tree_count', defaultValue: 0);
    _currentStreak = box.get('current_streak', defaultValue: 0);
    final lastDateStr = box.get('last_focus_date');
    if (lastDateStr != null) {
      _lastFocusDate = DateTime.parse(lastDateStr);
    }
    _checkStreakReset();
    notifyListeners();
  }

  void _checkStreakReset() {
    if (_lastFocusDate == null) return;
    
    final now = DateTime.now();
    final difference = now.difference(_lastFocusDate!).inDays;
    
    // Reset streak if more than 1 day has passed since last focus
    if (difference > 1) {
      _currentStreak = 0;
      _saveStreak();
    }
  }

  Future<void> startFocus() async {
    if (_isFocusing) return;

    _isFocusing = true;
    _timeLeft = _sessionDuration;
    _treeStatus = TreeStatus.seed;
    notifyListeners();

    // Start ambient sound
    await _playAmbientSound();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        _updateTreeStatus();
        notifyListeners();
      } else {
        _completeSession();
      }
    });
  }

  Future<void> _playAmbientSound() async {
    if (_ambientSound == 'Silence') {
      await _audioPlayer.stop();
      return;
    }

    try {
      // Map sound names to asset paths
      final soundMap = {
        'Rain': 'sounds/rain.mp3',
        'Fire': 'sounds/fire.mp3',
        'Night': 'sounds/night.mp3',
        'Library': 'sounds/library.mp3',
      };

      final assetPath = soundMap[_ambientSound];
      if (assetPath != null) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource(assetPath));
      }
    } catch (e) {
      debugPrint('⚠️ Could not play ambient sound: $e');
    }
  }

  Future<void> _stopAmbientSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('⚠️ Could not stop ambient sound: $e');
    }
  }

  void _updateTreeStatus() {
    if (!_isFocusing) return;
    
    final progress = 1 - (_timeLeft / _sessionDuration);
    
    if (progress < 0.25) {
      _treeStatus = TreeStatus.seed;
    } else if (progress < 0.50) {
      _treeStatus = TreeStatus.sprout;
    } else if (progress < 0.75) {
      _treeStatus = TreeStatus.tree; // Small tree
    } else {
      _treeStatus = TreeStatus.tree; // Mature tree logic handled by icon/color
    }
  }

  Future<void> _killTree() async {
    _timer?.cancel();
    await _stopAmbientSound();
    
    // Save dead tree to history
    final minutesStudied = (_sessionDuration - _timeLeft) ~/ 60;
    await _saveToHistory(minutesStudied, 'dead');
    
    _isFocusing = false;
    _timeLeft = 0;
    _treeStatus = TreeStatus.dead;
    
    // Reset streak on failure
    _currentStreak = 0;
    await _saveStreak();
    
    notifyListeners();
    debugPrint('🔴 Focus killed: User left the app');
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    await _stopAmbientSound();
    
    _isFocusing = false;
    _treeStatus = TreeStatus.tree;
    
    // Save to forest
    final box = await Hive.openBox('user_forest');
    final currentCount = box.get('tree_count', defaultValue: 0);
    await box.put('tree_count', currentCount + 1);
    _forestCount = currentCount + 1;
    
    // Update Streak
    _updateStreak();
    
    // Save to history
    final minutesStudied = _sessionDuration ~/ 60;
    await _saveToHistory(minutesStudied, 'alive');
    
    notifyListeners();
    debugPrint('✅ Focus completed! Total trees: $_forestCount');
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    
    if (_lastFocusDate == null) {
      _currentStreak = 1;
    } else {
      final difference = now.difference(_lastFocusDate!).inDays;
      if (difference == 1) {
        _currentStreak++;
      } else if (difference > 1) {
        _currentStreak = 1;
      }
      // If difference is 0 (same day), streak doesn't increase but doesn't reset
    }
    
    _lastFocusDate = now;
    await _saveStreak();
  }

  Future<void> _saveStreak() async {
    final box = await Hive.openBox('user_forest');
    await box.put('current_streak', _currentStreak);
    if (_lastFocusDate != null) {
      await box.put('last_focus_date', _lastFocusDate!.toIso8601String());
    }
  }

  Future<void> _saveToHistory(int minutes, String status) async {
    try {
      final box = await Hive.openBox('forest_history');
      final history = box.get('trees', defaultValue: <Map<String, dynamic>>[]) as List;
      
      history.add({
        'date': DateTime.now().toIso8601String(),
        'minutes': minutes,
        'status': status,
      });
      
      await box.put('trees', history);
    } catch (e) {
      debugPrint('⚠️ Could not save to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final box = await Hive.openBox('forest_history');
      final history = box.get('trees', defaultValue: <Map<String, dynamic>>[]) as List;
      // Sort by date descending
      final typedHistory = history.cast<Map<String, dynamic>>();
      typedHistory.sort((a, b) => b['date'].compareTo(a['date']));
      return typedHistory;
    } catch (e) {
      debugPrint('⚠️ Could not load history: $e');
      return [];
    }
  }

  int getTotalFocusHours() {
    // This will be calculated from history in the UI if needed
    return 0;
  }

  void resetTree() {
    _treeStatus = TreeStatus.none;
    _timeLeft = 0;
    notifyListeners();
  }

  String formatTime() {
    final minutes = _timeLeft ~/ 60;
    final seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get tree icon based on minutes studied (Static for history)
  static IconData getTreeIconByMinutes(int minutes) {
    if (minutes < 15) {
      return Icons.grass; // Small plant
    } else if (minutes < 30) {
      return Icons.park; // Regular tree
    } else if (minutes < 60) {
      return Icons.forest; // Dense tree
    } else {
      return Icons.nature_people; // Grand tree (Unlockable)
    }
  }

  // Get tree color based on minutes (Static for history)
  static Color getTreeColorByMinutes(int minutes) {
    if (minutes < 15) {
      return Colors.brown;
    } else if (minutes < 30) {
      return Colors.lightGreen;
    } else if (minutes < 60) {
      return Colors.green;
    } else {
      return Colors.amber;
    }
  }

  // Get current tree icon (Instance)
  IconData getTreeIcon() {
    if (_treeStatus == TreeStatus.tree) {
      return getTreeIconByMinutes(_sessionDuration ~/ 60);
    }
    switch (_treeStatus) {
      case TreeStatus.seed:
        return Icons.grass;
      case TreeStatus.sprout:
        return Icons.local_florist;
      case TreeStatus.dead:
        return Icons.dangerous;
      case TreeStatus.none:
        return Icons.eco;
      default:
        return Icons.park;
    }
  }

  // Get current tree color (Instance)
  Color getTreeColor() {
    if (_treeStatus == TreeStatus.tree) {
       return getTreeColorByMinutes(_sessionDuration ~/ 60);
    }

    switch (_treeStatus) {
      case TreeStatus.seed:
        return Colors.brown;
      case TreeStatus.sprout:
        return Colors.lightGreen;
      case TreeStatus.dead:
        return Colors.red;
      case TreeStatus.none:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }
}
