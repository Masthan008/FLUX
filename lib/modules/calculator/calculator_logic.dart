import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String _expression = '';
  String _result = '0';

  String get expression => _expression;
  String get result => _result;

  void input(String text) {
    _expression += text;
  }

  void clear() {
    _expression = '';
    _result = '0';
  }

  void delete() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression.replaceAll('x', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Format result to remove trailing .0 if integer
      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toString();
      }
    } catch (e) {
      _result = 'Error';
    }
  }
}
