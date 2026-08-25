import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class SmartNumpad extends StatelessWidget {
  final String rawInput;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onSubmit;
  final bool canSubmit;

  const SmartNumpad({
    super.key,
    required this.rawInput,
    required this.onInputChanged,
    required this.onSubmit,
    this.canSubmit = true,
  });

  void _onKeyPress(String key) {
    HapticFeedback.selectionClick();

    if (key == 'C') {
      onInputChanged('');
      return;
    }

    if (key == '⌫') {
      if (rawInput.isNotEmpty) {
        onInputChanged(rawInput.substring(0, rawInput.length - 1));
      }
      return;
    }

    if (key == '+' || key == '-') {
      if (rawInput.isEmpty) return;
      final lastChar = rawInput[rawInput.length - 1];
      if (lastChar == '+' || lastChar == '-') {
        onInputChanged(rawInput.substring(0, rawInput.length - 1) + key);
      } else {
        // Evaluate previous expression if needed
        final evaluated = _evaluateExpression(rawInput);
        onInputChanged('$evaluated$key');
      }
      return;
    }

    if (key == '.') {
      // Find current active number segment after last operator
      final parts = rawInput.split(RegExp(r'[\+\-]'));
      final lastPart = parts.isNotEmpty ? parts.last : '';
      if (lastPart.contains('.')) return; // Already has dot in this segment
      if (rawInput.isEmpty || rawInput.endsWith('+') || rawInput.endsWith('-')) {
        onInputChanged('${rawInput}0.');
      } else {
        onInputChanged('$rawInput.');
      }
      return;
    }

    // Number keys 0-9
    // Limit max digits
    if (rawInput.length >= 12) return;

    if (rawInput == '0' && key != '.') {
      onInputChanged(key);
    } else {
      onInputChanged('$rawInput$key');
    }
  }

  static String _evaluateExpression(String expr) {
    if (expr.isEmpty) return '0';
    try {
      // Match basic + and -
      double total = 0.0;
      String currentOp = '+';
      String numBuffer = '';

      for (int i = 0; i < expr.length; i++) {
        final ch = expr[i];
        if (ch == '+' || ch == '-') {
          if (numBuffer.isNotEmpty) {
            final val = double.tryParse(numBuffer) ?? 0.0;
            total = currentOp == '+' ? total + val : total - val;
            numBuffer = '';
          }
          currentOp = ch;
        } else {
          numBuffer += ch;
        }
      }

      if (numBuffer.isNotEmpty) {
        final val = double.tryParse(numBuffer) ?? 0.0;
        total = currentOp == '+' ? total + val : total - val;
      }

      if (total == total.roundToDouble()) {
        return total.toInt().toString();
      } else {
        return total.toStringAsFixed(2);
      }
    } catch (_) {
      return expr;
    }
  }

  static double parseEvaluatedAmount(String input) {
    if (input.isEmpty) return 0.0;
    final evaluated = _evaluateExpression(input);
    return double.tryParse(evaluated) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = PColor.line(context);

    final keys = [
      ['7', '8', '9', '⌫'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '-'],
      ['C', '0', '.', '✓'],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: row.map((key) {
                final isAction = key == '✓';
                final isOp = key == '+' || key == '-' || key == '⌫' || key == 'C';

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Material(
                      color: isAction
                          ? (canSubmit
                              ? PColor.primary(context)
                              : PColor.primary(context).withValues(alpha: 0.5))
                          : (isOp
                              ? PColor.surfaceSubtle(context)
                              : PColor.surface(context)),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: isAction
                            ? () {
                                HapticFeedback.mediumImpact();
                                onSubmit();
                              }
                            : () => _onKeyPress(key),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isAction
                                  ? Colors.transparent
                                  : borderColor,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isAction
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : isOp && key == '⌫'
                                  ? Icon(
                                      Icons.backspace_outlined,
                                      size: 18,
                                      color: PColor.ink(context),
                                    )
                                  : Text(
                                      key,
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 18,
                                        fontWeight: isOp
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: isOp
                                            ? PColor.primary(context)
                                            : PColor.ink(context),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

