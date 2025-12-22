
import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculatorProvider with ChangeNotifier {
  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;

  String get expression => _expression;
  String get result => _result;

  void addToExpression(String value) {
    if (_justEvaluated) {
      // If user starts typing a number immediately after result, cleared?
      // Or just appended?
      // User said: "if not the former addition will be used".
      // Usually calculators reset if number, append if operator.
      // But let's stick to the specific request about Equation Sign first.
      // For now, I will just reset the flag so normal appending happens.
      _justEvaluated = false;
    }
    _expression += value;
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    _justEvaluated = false;
    notifyListeners();
  }

  void delete() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _justEvaluated = false;
      notifyListeners();
    }
  }

  void evaluate() {
    if (_justEvaluated) {
      // User pressed = again immediately.
      // Move result to expression to allow continuing configuration
      if (_result != 'Error') {
        _expression = _result;
        // _result = ''; // Optional: clear result or keep it?
        // Keeping it is fine, but visually maybe better to just show it in expression.
        // Let's keep it in result too, but now expression is "4".
        // If they press + it becomes 4+.
      }
      _justEvaluated = false;
      notifyListeners();
      return;
    }

    try {
      Parser p = Parser();
      // Replace visual symbols with supported operators if needed
      // e.g. '×' -> '*', '÷' -> '/'
      String finalExpression = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '3.14159265')
          .replaceAll('e', '2.71828182');

      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Simple formatting to remove trailing .0
      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toString();
      }
      _justEvaluated = true;
    } catch (e) {
      _result = 'Error';
      _justEvaluated = false;
    }
    notifyListeners();
  }
}
