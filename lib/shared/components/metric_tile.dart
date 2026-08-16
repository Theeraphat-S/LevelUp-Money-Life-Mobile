import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

enum MetricTone { jade, primary, rose, amber, moss, neutral }

class MetricTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;
  final String? subtext;
  final MetricTone tone;
  final VoidCallback? onClick;

  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtext,
    this.tone = MetricTone.neutral,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color iconBg;
    Color iconColor;
    Color valueColor;

    switch (tone) {
      case MetricTone.jade:
        iconBg = PColor.jadeSoft(context);
        iconColor = PColor.jade(context);
        valueColor = PColor.jadeInk(context);
        break;
      case MetricTone.primary:
        iconBg = PColor.primarySoft(context);
        iconColor = PColor.primary(context);
        valueColor = PColor.primaryInk(context);
        break;
      case MetricTone.rose:
        iconBg = PColor.roseSoft(context);
        iconColor = PColor.rose(context);
        valueColor = PColor.roseInk(context);
        break;
      case MetricTone.amber:
        iconBg = PColor.amberSoft(context);
        iconColor = PColor.amber(context);
        valueColor = PColor.amberInk(context);
        break;
      case MetricTone.moss:
        iconBg = PColor.mossSoft(context);
        iconColor = PColor.moss(context);
        valueColor = PColor.mossInk(context);
        break;
      case MetricTone.neutral:
        iconBg = PColor.surfaceSubtle(context);
        iconColor = PColor.inkSoft(context);
        valueColor = PColor.ink(context);
        break;
    }

    final tile = Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: PColor.surface(context),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: PColor.line(context), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0x33000000)
                : const Color(0x0A142D2B),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconTheme(
                  data: IconThemeData(color: iconColor, size: 16),
                  child: icon,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: PColor.inkSoft(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtext != null && subtext!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtext!,
              style: TextStyle(
                fontSize: 11,
                color: PColor.inkFaint(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );

    if (onClick != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.0),
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(14.0),
          child: tile,
        ),
      );
    }

    return tile;
  }
}
