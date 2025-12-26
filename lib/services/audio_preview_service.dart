import 'package:audioplayers/audioplayers.dart';

class AudioPreviewService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static bool get isPlaying => _isPlaying;

  static Future<void> playPreview(String path) async {
    try {
      await stopPreview(); // Stop any existing playback
      
      // Remove 'assets/' prefix if present because AudioPlayer adds it automatically for local assets
      // Wait, AudioPlayer Source.asset expects path relative to assets? 
      // Or does it expect 'assets/sounds/...'?
      // Documentation says: "The path is relative to the asset folder."
      // So if our file is at 'assets/sounds/alarm_1.mp3', we might need to pass 'sounds/alarm_1.mp3' if 'assets' is the root.
      // But usually in Flutter 'assets' is just a folder.
      // Let's try passing the full path first, if it fails we adjust.
      // Actually, AssetSource adds 'assets/' prefix by default.
      
      String cleanPath = path;
      if (path.startsWith('assets/')) {
        cleanPath = path.substring(7); // Remove 'assets/'
      }

      await _player.play(AssetSource(cleanPath));
      _isPlaying = true;

      // Auto stop after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (_isPlaying) {
          stopPreview();
        }
      });
    } catch (e) {
      print("Error playing preview: $e");
    }
  }

  static Future<void> stopPreview() async {
    await _player.stop();
    _isPlaying = false;
  }
}
