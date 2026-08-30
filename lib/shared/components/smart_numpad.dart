import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

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
    HapticFeedback.lightImpact();

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

                final bgColor = isAction
                    ? (canSubmit
                        ? PColor.primary(context)
                        : PColor.primary(context).withValues(alpha: 0.5))
                    : (isOp
                        ? PColor.surfaceSubtle(context)
                        : PColor.surface(context));

                final border = isAction
                    ? null
                    : Border.all(color: borderColor, width: 1);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: _NumpadButton(
                      backgroundColor: bgColor,
                      border: border,
                      borderRadius: BorderRadius.circular(12),
                      onTap: isAction
                          ? () {
                              HapticFeedback.mediumImpact();
                              onSubmit();
                            }
                          : () => _onKeyPress(key),
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
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NumpadButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Border? border;
  final BorderRadius borderRadius;

  const _NumpadButton({
    required this.child,
    required this.onTap,
    required this.backgroundColor,
    this.border,
    required this.borderRadius,
  });

  @override
  State<_NumpadButton> createState() => _NumpadButtonState();
}

class _NumpadButtonState extends State<_NumpadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap != null ? _handleTapDown : null,
      onTapUp: widget.onTap != null ? _handleTapUp : null,
      onTapCancel: widget.onTap != null ? _handleTapCancel : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
              border: widget.border,
            ),
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

