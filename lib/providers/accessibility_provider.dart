import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityProvider extends ChangeNotifier {
  static const String _accessibilityBoxKey = 'accessibility_settings';
  late Box _accessibilityBox;
  
  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  
  // Text to Speech
  late FlutterTts _flutterTts;
  bool _isSpeaking = false;
  
  // Settings
  bool _screenReaderEnabled = false;
  bool _voiceCommandsEnabled = false;
  bool _gestureControlsEnabled = false;
  double _speechRate = 0.5;
  double _speechPitch = 1.0;
  String _speechLanguage = 'en-US';
  bool _hapticFeedbackEnabled = true;
  bool _reduceAnimations = false;
  bool _largeText = false;
  bool _highContrast = false;
  
  // Voice Commands
  final Map<String, VoidCallback> _voiceCommands = {};
  
  // Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get lastWords => _lastWords;
  bool get screenReaderEnabled => _screenReaderEnabled;
  bool get voiceCommandsEnabled => _voiceCommandsEnabled;
  bool get gestureControlsEnabled => _gestureControlsEnabled;
  double get speechRate => _speechRate;
  double get speechPitch => _speechPitch;
  String get speechLanguage => _speechLanguage;
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;
  bool get reduceAnimations => _reduceAnimations;
  bool get largeText => _largeText;
  bool get highContrast => _highContrast;

  AccessibilityProvider() {
    _initializeAccessibility();
  }

  Future<void> _initializeAccessibility() async {
    try {
      _accessibilityBox = await Hive.openBox(_accessibilityBoxKey);
      _loadAccessibilitySettings();
      
      // Initialize Speech to Text
      _speech = stt.SpeechToText();
      await _speech.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );
      
      // Initialize Text to Speech
      _flutterTts = FlutterTts();
      await _flutterTts.setLanguage(_speechLanguage);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_speechPitch);
      
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });
      
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        notifyListeners();
      });
      
      _setupVoiceCommands();
      
    } catch (e) {
      debugPrint('Error initializing accessibility: $e');
    }
  }

  void _loadAccessibilitySettings() {
    _screenReaderEnabled = _accessibilityBox.get('screenReaderEnabled', defaultValue: false);
    _voiceCommandsEnabled = _accessibilityBox.get('voiceCommandsEnabled', defaultValue: false);
    _gestureControlsEnabled = _accessibilityBox.get('gestureControlsEnabled', defaultValue: false);
    _speechRate = _accessibilityBox.get('speechRate', defaultValue: 0.5);
    _speechPitch = _accessibilityBox.get('speechPitch', defaultValue: 1.0);
    _speechLanguage = _accessibilityBox.get('speechLanguage', defaultValue: 'en-US');
    _hapticFeedbackEnabled = _accessibilityBox.get('hapticFeedbackEnabled', defaultValue: true);
    _reduceAnimations = _accessibilityBox.get('reduceAnimations', defaultValue: false);
    _largeText = _accessibilityBox.get('largeText', defaultValue: false);
    _highContrast = _accessibilityBox.get('highContrast', defaultValue: false);
    notifyListeners();
  }

  Future<void> _saveAccessibilitySettings() async {
    try {
      await _accessibilityBox.put('screenReaderEnabled', _screenReaderEnabled);
      await _accessibilityBox.put('voiceCommandsEnabled', _voiceCommandsEnabled);
      await _accessibilityBox.put('gestureControlsEnabled', _gestureControlsEnabled);
      await _accessibilityBox.put('speechRate', _speechRate);
      await _accessibilityBox.put('speechPitch', _speechPitch);
      await _accessibilityBox.put('speechLanguage', _speechLanguage);
      await _accessibilityBox.put('hapticFeedbackEnabled', _hapticFeedbackEnabled);
      await _accessibilityBox.put('reduceAnimations', _reduceAnimations);
      await _accessibilityBox.put('largeText', _largeText);
      await _accessibilityBox.put('highContrast', _highContrast);
    } catch (e) {
      debugPrint('Error saving accessibility settings: $e');
    }
  }

  void _setupVoiceCommands() {
    _voiceCommands.clear();
    // Add common voice commands - these will be set by screens
  }

  // Screen Reader Functions
  void toggleScreenReader() {
    _screenReaderEnabled = !_screenReaderEnabled;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  Future<void> speak(String text) async {
    if (_screenReaderEnabled && text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  // Voice Commands
  void toggleVoiceCommands() {
    _voiceCommandsEnabled = !_voiceCommandsEnabled;
    if (!_voiceCommandsEnabled && _isListening) {
      stopListening();
    }
    _saveAccessibilitySettings();
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_voiceCommandsEnabled) return;
    
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      notifyListeners();
      
      _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords.toLowerCase();
          _processVoiceCommand(_lastWords);
          notifyListeners();
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  void _processVoiceCommand(String command) {
    for (String key in _voiceCommands.keys) {
      if (command.contains(key)) {
        _voiceCommands[key]?.call();
        if (_hapticFeedbackEnabled) {
          HapticFeedback.lightImpact();
        }
        break;
      }
    }
  }

  void registerVoiceCommand(String command, VoidCallback callback) {
    _voiceCommands[command.toLowerCase()] = callback;
  }

  void clearVoiceCommands() {
    _voiceCommands.clear();
  }

  // Gesture Controls
  void toggleGestureControls() {
    _gestureControlsEnabled = !_gestureControlsEnabled;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  // Speech Settings
  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.1, 1.0);
    _flutterTts.setSpeechRate(_speechRate);
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void setSpeechPitch(double pitch) {
    _speechPitch = pitch.clamp(0.5, 2.0);
    _flutterTts.setPitch(_speechPitch);
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void setSpeechLanguage(String language) {
    _speechLanguage = language;
    _flutterTts.setLanguage(_speechLanguage);
    _saveAccessibilitySettings();
    notifyListeners();
  }

  // Other Settings
  void toggleHapticFeedback() {
    _hapticFeedbackEnabled = !_hapticFeedbackEnabled;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void toggleReduceAnimations() {
    _reduceAnimations = !_reduceAnimations;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void setLargeText(bool value) {
    _largeText = value;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void setHighContrast(bool value) {
    _highContrast = value;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  void setReduceAnimations(bool value) {
    _reduceAnimations = value;
    _saveAccessibilitySettings();
    notifyListeners();
  }

  // Utility Functions
  void provideFeedback({String? text, bool haptic = true}) {
    if (text != null && _screenReaderEnabled) {
      speak(text);
    }
    if (haptic && _hapticFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  Duration getAnimationDuration(Duration defaultDuration) {
    return _reduceAnimations 
        ? Duration(milliseconds: (defaultDuration.inMilliseconds * 0.3).round())
        : defaultDuration;
  }
}