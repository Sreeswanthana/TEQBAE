import 'package:flutter/material.dart';
import '../../modules/dev_tools/views/dev_simulation_sheet.dart';
import '../../modules/dev_tools/views/theme_helper_sheet.dart';
import '../theme/theme_helper.dart';

/// Compact header actions shared by workspace screens.
class ChromeActions extends StatelessWidget {
  const ChromeActions({super.key, this.includeSimulation = true, this.onDark = false});

  final bool includeSimulation;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark ? Colors.white : ThemeHelper.textPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Display mode',
          visualDensity: VisualDensity.compact,
          onPressed: () => ThemeHelperSheet.show(context),
          icon: Icon(Icons.contrast, size: 20, color: color),
        ),
        if (includeSimulation)
          IconButton(
            tooltip: 'Location simulation',
            visualDensity: VisualDensity.compact,
            onPressed: () => DevSimulationSheet.show(context),
            icon: Icon(Icons.biotech_outlined, size: 20, color: color),
          ),
      ],
    );
  }
}
