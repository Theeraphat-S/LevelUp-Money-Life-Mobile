import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class BentoCard extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;

  const BentoCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceBg = backgroundColor ?? PColor.surface(context);
    final borderColor = PColor.line(context);
    final highlightColor =
        isDark ? const Color(0x1AFFFFFF) : const Color(0x66FFFFFF);

    Widget content = Container(
      decoration: BoxDecoration(
        color: surfaceBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0x66000000)
                : const Color(0x0E142D2B),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: PColor.surfaceSubtle(context),
                      border: Border(
                        bottom: BorderSide(color: borderColor, width: 1.0),
                      ),
                    ),
                    child: header!,
                  ),
                ],
                Padding(
                  padding: padding ?? const EdgeInsets.all(16.0),
                  child: child,
                ),
                if (footer != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: PColor.surfaceSubtle(context),
                      border: Border(
                        top: BorderSide(color: borderColor, width: 1.0),
                      ),
                    ),
                    child: footer!,
                  ),
                ],
              ],
            ),
            // Liquid glass top highlight line (1px)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1.0,
              child: Container(color: highlightColor),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}
