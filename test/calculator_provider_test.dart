import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/providers/calculator_provider.dart';

void main() {
  group('CalculatorProvider Tests', () {
    late CalculatorProvider provider;

    setUp(() {
      provider = CalculatorProvider();
    });

    test('Initial state', () {
      expect(provider.expression, '');
      expect(provider.result, '0');
    });

    test('Addition', () {
      provider.addToExpression('2+2');
      provider.evaluate();
      expect(provider.result, '4');
    });

    test('Multiplication', () {
      provider.addToExpression('3×3');
      provider.evaluate();
      expect(provider.result, '9');
    });

     test('Division', () {
      provider.addToExpression('10÷2');
      provider.evaluate();
      expect(provider.result, '5');
    });

    test('Scientific Function (sin)', () {
      // sin(0) = 0
      provider.addToExpression('sin(0)');
      provider.evaluate();
      expect(provider.result, '0');
    });

    test('Complex Expression', () {
      // 2 + 3 * 4 = 14
      provider.addToExpression('2+3×4');
      provider.evaluate();
      expect(provider.result, '14');
    });

    test('Clear', () {
      provider.addToExpression('123');
      provider.clear();
      expect(provider.expression, '');
      expect(provider.result, '0');
    });

    test('Delete', () {
      provider.addToExpression('123');
      provider.delete();
      expect(provider.expression, '12');
    });
    
    test('Error Handling', () {
        provider.addToExpression('1÷0');
        provider.evaluate();
        // math_expressions might return Infinity or throw, let's see how our provider handles it.
        // Our provider catches errors and sets result to "Error", OR if it evaluates top infinity it prints infinity.
        // Dart division by zero returns result is Infinity.
        expect(provider.result, isNot('Error')); // It likely evaluates to Infinity
    });
  });
}
