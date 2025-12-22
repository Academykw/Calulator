import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Color definitions based on theme is handled by accessing Theme.of(context)
    // but some specific overrides can be useful.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Operator color
    final opColor = isDark ? Colors.orange[700] : Colors.orange;
    final opTextColor = Colors.white;

    // Scientific func color
    final sciColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final sciTextColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joe Annel Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        calcProvider.expression,
                        style: const TextStyle(fontSize: 32, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        calcProvider.result,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            // Keypad Area
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // Row 1: Scientific functions
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: 'sin', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('sin('), fontSize: 18),
                        CalculatorButton(label: 'cos', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('cos('), fontSize: 18),
                        CalculatorButton(label: 'tan', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('tan('), fontSize: 18),
                        CalculatorButton(label: 'log', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('log('), fontSize: 18),
                         CalculatorButton(label: 'ln', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('ln('), fontSize: 18),
                      ],
                    ),
                  ),
                   // Row 2: More Sci + Clear
                   Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: '(', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('(')),
                        CalculatorButton(label: ')', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression(')')),
                        CalculatorButton(label: '^', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('^')),
                        CalculatorButton(label: '√', backgroundColor: sciColor, textColor: sciTextColor, onPressed: () => calcProvider.addToExpression('sqrt(')), 
                        CalculatorButton(label: 'C', backgroundColor: Colors.red[400], textColor: Colors.white, onPressed: () => calcProvider.clear()),
                      ],
                    ),
                  ),
                  // Row 3: 7 8 9 /
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: '7', onPressed: () => calcProvider.addToExpression('7')),
                        CalculatorButton(label: '8', onPressed: () => calcProvider.addToExpression('8')),
                        CalculatorButton(label: '9', onPressed: () => calcProvider.addToExpression('9')),
                        CalculatorButton(label: 'D', // Delete
                          backgroundColor: Colors.red[200],
                          textColor: Colors.black,
                          onPressed: () => calcProvider.delete()
                        ),
                        CalculatorButton(label: '÷', backgroundColor: opColor, textColor: opTextColor, onPressed: () => calcProvider.addToExpression('÷')),
                      ],
                    ),
                  ),
                  // Row 4: 4 5 6 *
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: '4', onPressed: () => calcProvider.addToExpression('4')),
                        CalculatorButton(label: '5', onPressed: () => calcProvider.addToExpression('5')),
                        CalculatorButton(label: '6', onPressed: () => calcProvider.addToExpression('6')),
                         CalculatorButton(label: 'π', onPressed: () => calcProvider.addToExpression('π')),
                        CalculatorButton(label: '×', backgroundColor: opColor, textColor: opTextColor, onPressed: () => calcProvider.addToExpression('×')),
                      ],
                    ),
                  ),
                  // Row 5: 1 2 3 -
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: '1', onPressed: () => calcProvider.addToExpression('1')),
                        CalculatorButton(label: '2', onPressed: () => calcProvider.addToExpression('2')),
                        CalculatorButton(label: '3', onPressed: () => calcProvider.addToExpression('3')),
                        CalculatorButton(label: 'e', onPressed: () => calcProvider.addToExpression('e')),
                        CalculatorButton(label: '-', backgroundColor: opColor, textColor: opTextColor, onPressed: () => calcProvider.addToExpression('-')),
                      ],
                    ),
                  ),
                  // Row 6: 0 . = +
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalculatorButton(label: '0', flex: 2, onPressed: () => calcProvider.addToExpression('0')),
                        CalculatorButton(label: '.', onPressed: () => calcProvider.addToExpression('.')),
                        CalculatorButton(label: '=', backgroundColor: Colors.green, textColor: Colors.white, onPressed: () => calcProvider.evaluate()),
                         CalculatorButton(label: '+', backgroundColor: opColor, textColor: opTextColor, onPressed: () => calcProvider.addToExpression('+')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
