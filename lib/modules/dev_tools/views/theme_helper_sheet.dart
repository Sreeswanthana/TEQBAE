import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/brand_art.dart';

class ThemeHelperSheet extends StatefulWidget {
  const ThemeHelperSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ThemeHelperSheet(),
    );
  }

  @override
  State<ThemeHelperSheet> createState() => _ThemeHelperSheetState();
}

class _ThemeHelperSheetState extends State<ThemeHelperSheet> {
  late AppThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = ThemeHelper.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      return Container(
        decoration: BoxDecoration(
          color: RebsLook.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 42, height: 4, decoration: BoxDecoration(color: RebsLook.lineColor, borderRadius: BorderRadius.circular(4))),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const BrandIcon(BrandArt.gear, size: 32),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Theme & Display Helper', style: TypeScale.display(22, color: RebsLook.inkColor))),
                ],
              ),
              Text(
                'Select your preferred workspace visual mode',
                style: TypeScale.body(size: 12, weight: FontWeight.w400, color: RebsLook.muteColor),
              ),
              const SizedBox(height: 14),
              _option(
                AppThemeMode.light,
                'Light Mode',
                'Crisp daytime workspace with white cards and blue accents.',
                const [Color(0xFFF8FAFC), Colors.white, Color(0xFF2563EB)],
              ),
              _option(
                AppThemeMode.dark,
                'Dark Mode',
                'Deep midnight slate. Easier on the eyes in low light.',
                const [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF3B82F6)],
              ),
              _option(
                AppThemeMode.eyeComfort,
                'Dark Eye Comfort Mode',
                'Warm espresso and amber shield for evening shifts.',
                const [Color(0xFF181512), Color(0xFF26221D), Color(0xFFF59E0B)],
                badge: 'EYE CARE SHIELD',
              ),
              const SizedBox(height: 8),
              RebsLook.button(
                label: 'Apply Selected Theme',
                icon: Icons.check_rounded,
                onPressed: () {
                  ThemeHelper.setTheme(_selectedMode);
                  if (context.mounted) Navigator.pop(context);
                  Get.snackbar(
                    'Theme Applied',
                    _selectedMode == AppThemeMode.eyeComfort
                        ? 'Switched to Dark Eye Comfort Mode (Eye Care Shield Active)'
                        : (_selectedMode == AppThemeMode.dark
                            ? 'Switched to Dark Mode (Midnight Slate Active)'
                            : 'Switched to Light Mode (Daytime Workspace Active)'),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: RebsLook.navyDeep,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 16,
                    duration: const Duration(seconds: 3),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _choose(AppThemeMode mode) {
    setState(() => _selectedMode = mode);
    ThemeHelper.setTheme(mode);
  }

  Widget _option(AppThemeMode mode, String title, String subtitle, List<Color> swatch, {String? badge}) {
    final selected = _selectedMode == mode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _choose(mode),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? RebsLook.action.withValues(alpha: 0.08) : RebsLook.canvas,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? RebsLook.action : RebsLook.lineColor, width: selected ? 1.6 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: swatch.first, borderRadius: BorderRadius.circular(12), border: Border.all(color: swatch.last)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor)),
                    Text(subtitle, style: TypeScale.body(size: 11, weight: FontWeight.w400, color: RebsLook.muteColor)),
                    if (badge != null)
                      Text(badge, style: TypeScale.body(size: 10, weight: FontWeight.w800, color: RebsLook.amber)),
                  ],
                ),
              ),
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? RebsLook.action : RebsLook.muteColor),
            ],
          ),
        ),
      ),
    );
  }
}
