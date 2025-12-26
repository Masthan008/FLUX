import 'package:hive_flutter/hive_flutter.dart';

class GameTimeService {
  static const int maxPlayTimeMinutes = 20;
  static const int cooldownMinutes = 60;
  
  static Future<bool> canPlayGame(String gameName) async {
    final box = Hive.box('user_prefs');
    final lastPlayedStr = box.get('game_last_played_$gameName');
    final totalPlayTimeToday = box.get('game_time_today_$gameName', defaultValue: 0);
    
    final now = DateTime.now();
    
    // Check if it's a new day - reset counters
    final lastResetStr = box.get('game_last_reset');
    if (lastResetStr != null) {
      final lastReset = DateTime.parse(lastResetStr);
      if (!_isSameDay(lastReset, now)) {
        // New day - reset all game times
        await _resetAllGameTimes();
        return true;
      }
    } else {
      await box.put('game_last_reset', now.toIso8601String());
    }
    
    // Check if user has exceeded play time for today
    if (totalPlayTimeToday >= maxPlayTimeMinutes) {
      // Check if cooldown period has passed
      if (lastPlayedStr != null) {
        final lastPlayed = DateTime.parse(lastPlayedStr);
        final timeSinceLastPlay = now.difference(lastPlayed).inMinutes;
        
        if (timeSinceLastPlay < cooldownMinutes) {
          return false; // Still in cooldown
        } else {
          // Cooldown passed, reset time for this game
          await box.put('game_time_today_$gameName', 0);
          return true;
        }
      }
    }
    
    return true;
  }
  
  static Future<void> startGameSession(String gameName) async {
    final box = Hive.box('user_prefs');
    final now = DateTime.now();
    await box.put('game_session_start_$gameName', now.toIso8601String());
  }
  
  static Future<void> endGameSession(String gameName) async {
    final box = Hive.box('user_prefs');
    final startStr = box.get('game_session_start_$gameName');
    
    if (startStr != null) {
      final start = DateTime.parse(startStr);
      final now = DateTime.now();
      final sessionMinutes = now.difference(start).inMinutes;
      
      // Add session time to total
      final totalPlayTimeToday = box.get('game_time_today_$gameName', defaultValue: 0);
      await box.put('game_time_today_$gameName', totalPlayTimeToday + sessionMinutes);
      await box.put('game_last_played_$gameName', now.toIso8601String());
      
      // Clear session start
      await box.delete('game_session_start_$gameName');
    }
  }
  
  static Future<Map<String, dynamic>> getGameStatus(String gameName) async {
    final box = Hive.box('user_prefs');
    final totalPlayTimeToday = box.get('game_time_today_$gameName', defaultValue: 0);
    final lastPlayedStr = box.get('game_last_played_$gameName');
    
    final remainingMinutes = maxPlayTimeMinutes - totalPlayTimeToday;
    final canPlay = await canPlayGame(gameName);
    
    int cooldownRemainingMinutes = 0;
    if (!canPlay && lastPlayedStr != null) {
      final lastPlayed = DateTime.parse(lastPlayedStr);
      final timeSinceLastPlay = DateTime.now().difference(lastPlayed).inMinutes;
      cooldownRemainingMinutes = cooldownMinutes - timeSinceLastPlay;
    }
    
    return {
      'canPlay': canPlay,
      'totalPlayedToday': totalPlayTimeToday,
      'remainingMinutes': remainingMinutes > 0 ? remainingMinutes : 0,
      'cooldownRemainingMinutes': cooldownRemainingMinutes > 0 ? cooldownRemainingMinutes : 0,
    };
  }
  
  static Future<void> _resetAllGameTimes() async {
    final box = Hive.box('user_prefs');
    final keys = box.keys.where((key) => 
      key.toString().startsWith('game_time_today_') || 
      key.toString().startsWith('game_last_played_')
    ).toList();
    
    for (final key in keys) {
      await box.delete(key);
    }
    
    await box.put('game_last_reset', DateTime.now().toIso8601String());
  }
  
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  static String getTimeRemainingMessage(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
      return '$hours hour${hours > 1 ? 's' : ''} $mins min${mins > 1 ? 's' : ''}';
    }
    return '$minutes minute${minutes > 1 ? 's' : ''}';
  }
}
