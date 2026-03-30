import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class HistoryItem {
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryItem({required this.expression, required this.result, required this.timestamp});
}

class CalculatorProvider with ChangeNotifier {
  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;
  final List<HistoryItem> _history = [];

  String get expression => _expression;
  String get result => _result;
  List<HistoryItem> get history => List.unmodifiable(_history);

  void addToExpression(String value) {
    if (_justEvaluated) {
      // If it's a number, start fresh expression
      if (RegExp(r'^[0-9.]+$').hasMatch(value)) {
        _expression = value;
      } else {
        // If it's an operator, append to result
        _expression = _result + value;
      }
      _justEvaluated = false;
    } else {
      _expression += value;
    }
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
    if (_expression.isEmpty) return;

    try {
      String finalExpression = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '3.14159265')
          .replaceAll('e', '2.71828182');

      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      String evalStr;
      if (eval % 1 == 0) {
        evalStr = eval.toInt().toString();
      } else {
        evalStr = eval.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
      }

      _history.insert(0, HistoryItem(
        expression: _expression,
        result: evalStr,
        timestamp: DateTime.now(),
      ));

      _result = evalStr;
      _justEvaluated = true;
    } catch (e) {
      _result = 'Error';
      _justEvaluated = false;
    }
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  void useHistoryItem(HistoryItem item) {
    _expression = item.expression;
    _result = item.result;
    _justEvaluated = true;
    notifyListeners();
  }
}
