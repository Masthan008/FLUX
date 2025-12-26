import 'package:hive_flutter/hive_flutter.dart';

class CalculatorHistory {
  static const String _boxName = 'calculator_history';

  static Box<String> get _box => Hive.box<String>(_boxName);

  static List<String> getHistory() {
    return _box.values.toList().reversed.toList();
  }

  static Future<void> addEntry(String entry) async {
    if (_box.length >= 10) {
      await _box.deleteAt(0); // Remove oldest
    }
    await _box.add(entry);
  }

  static Future<void> clearHistory() async {
    await _box.clear();
  }
}
