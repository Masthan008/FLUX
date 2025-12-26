import 'package:flutter/material.dart';
import 'calculator_logic.dart';
import 'calculator_history.dart';

class CalculatorProvider extends ChangeNotifier {
  final CalculatorLogic _logic = CalculatorLogic();
  
  String get expression => _logic.expression;
  String get result => _logic.result;
  List<String> get history => CalculatorHistory.getHistory();

  void input(String text) {
    _logic.input(text);
    notifyListeners();
  }

  void clear() {
    _logic.clear();
    notifyListeners();
  }

  void delete() {
    _logic.delete();
    notifyListeners();
  }

  void calculate() {
    final String prevExpression = _logic.expression;
    _logic.calculate();
    
    if (_logic.result != 'Error' && prevExpression.isNotEmpty) {
      CalculatorHistory.addEntry('$prevExpression = ${_logic.result}');
    }
    notifyListeners();
  }

  void clearHistory() {
    CalculatorHistory.clearHistory();
    notifyListeners();
  }
}
