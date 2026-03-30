import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final int flex;
  final bool isIcon;
  final IconData? icon;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 22.0,
    this.flex = 1,
    this.isIcon = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg = backgroundColor ?? (isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface);
    Color textCol = textColor ?? colorScheme.onSurface;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: bg,
          elevation: isDark ? 0 : 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: isIcon && icon != null
                  ? Icon(icon, color: textCol, size: 28)
                  : Text(
                      label,
                      style: TextStyle(
                        color: textCol,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'RobotoMono', // If available, or just default
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
