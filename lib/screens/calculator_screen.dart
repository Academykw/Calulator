import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Consumer<CalculatorProvider>(
          builder: (context, calcProvider, child) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => calcProvider.clearHistory(),
                        tooltip: 'Clear History',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: calcProvider.history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.history, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
                              const SizedBox(height: 16),
                              const Text('No history yet', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: calcProvider.history.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = calcProvider.history[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              title: Text(item.expression, 
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Theme.of(context).colorScheme.onSurfaceVariant
                                )
                              ),
                              subtitle: Text(item.result,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary)),
                              onTap: () {
                                calcProvider.useHistoryItem(item);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ada Bella Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showHistory(context),
          ),
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: calcProvider.result));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Result copied'),
                    behavior: SnackBarBehavior.floating,
                    width: 150,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        calcProvider.expression,
                        style: TextStyle(
                          fontSize: 26,
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        calcProvider.result,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Keypad Area
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            ),
            child: Column(
              children: [
                // Scientific row scrollable for more features
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _smallButton('sin', () => calcProvider.addToExpression('sin('), colorScheme),
                      _smallButton('cos', () => calcProvider.addToExpression('cos('), colorScheme),
                      _smallButton('tan', () => calcProvider.addToExpression('tan('), colorScheme),
                      _smallButton('log', () => calcProvider.addToExpression('log('), colorScheme),
                      _smallButton('ln', () => calcProvider.addToExpression('ln('), colorScheme),
                      _smallButton('(', () => calcProvider.addToExpression('('), colorScheme),
                      _smallButton(')', () => calcProvider.addToExpression(')'), colorScheme),
                      _smallButton('^', () => calcProvider.addToExpression('^'), colorScheme),
                      _smallButton('√', () => calcProvider.addToExpression('sqrt('), colorScheme),
                      _smallButton('π', () => calcProvider.addToExpression('π'), colorScheme),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Main Grid
                Row(
                  children: [
                    CalculatorButton(label: 'C', textColor: colorScheme.error, onPressed: () => calcProvider.clear()),
                    CalculatorButton(label: 'e', textColor: colorScheme.secondary, onPressed: () => calcProvider.addToExpression('e')),
                    CalculatorButton(label: '÷', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer, onPressed: () => calcProvider.addToExpression('÷')),
                    CalculatorButton(label: '⌫', isIcon: true, icon: Icons.backspace_outlined, textColor: colorScheme.secondary, onPressed: () => calcProvider.delete()),
                  ],
                ),
                Row(
                  children: [
                    CalculatorButton(label: '7', onPressed: () => calcProvider.addToExpression('7')),
                    CalculatorButton(label: '8', onPressed: () => calcProvider.addToExpression('8')),
                    CalculatorButton(label: '9', onPressed: () => calcProvider.addToExpression('9')),
                    CalculatorButton(label: '×', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer, onPressed: () => calcProvider.addToExpression('×')),
                  ],
                ),
                Row(
                  children: [
                    CalculatorButton(label: '4', onPressed: () => calcProvider.addToExpression('4')),
                    CalculatorButton(label: '5', onPressed: () => calcProvider.addToExpression('5')),
                    CalculatorButton(label: '6', onPressed: () => calcProvider.addToExpression('6')),
                    CalculatorButton(label: '-', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer, onPressed: () => calcProvider.addToExpression('-')),
                  ],
                ),
                Row(
                  children: [
                    CalculatorButton(label: '1', onPressed: () => calcProvider.addToExpression('1')),
                    CalculatorButton(label: '2', onPressed: () => calcProvider.addToExpression('2')),
                    CalculatorButton(label: '3', onPressed: () => calcProvider.addToExpression('3')),
                    CalculatorButton(label: '+', backgroundColor: colorScheme.primaryContainer, textColor: colorScheme.onPrimaryContainer, onPressed: () => calcProvider.addToExpression('+')),
                  ],
                ),
                Row(
                  children: [
                    CalculatorButton(label: '.', onPressed: () => calcProvider.addToExpression('.')),
                    CalculatorButton(label: '0', onPressed: () => calcProvider.addToExpression('0')),
                    CalculatorButton(label: '=', flex: 2, backgroundColor: colorScheme.primary, textColor: colorScheme.onPrimary, onPressed: () => calcProvider.evaluate()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onTap, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
