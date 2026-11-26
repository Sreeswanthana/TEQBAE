import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../core/services/location_service.dart';

class DevSimulationSheet extends StatefulWidget {
  const DevSimulationSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DevSimulationSheet(),
    );
  }

  @override
  State<DevSimulationSheet> createState() => _DevSimulationSheetState();
}

class _DevSimulationSheetState extends State<DevSimulationSheet> {
  late LocationService _locationService;
  late LocationSimulationMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _locationService = Get.find<LocationService>();
    final current = _locationService.simulationMode.value;
    _selectedMode = current == LocationSimulationMode.atOffice
        ? LocationSimulationMode.atOffice
        : LocationSimulationMode.realGps;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 42, height: 4, decoration: BoxDecoration(color: RebsLook.lineColor, borderRadius: BorderRadius.circular(4))),
            ),
            const SizedBox(height: 14),
            Text('Reviewer Simulation Panel', style: TypeScale.display(22, color: RebsLook.inkColor)),
            Text(
              'Office Location: Bangalore HQ (Fixed)',
              style: TypeScale.body(size: 12, weight: FontWeight.w400, color: RebsLook.muteColor),
            ),
            const SizedBox(height: 14),
            _card(
              LocationSimulationMode.realGps,
              'Current Location (Device GPS)',
              'Fetches real-time GPS coordinates directly from your device.',
              'Device GPS',
            ),
            const SizedBox(height: 10),
            _card(
              LocationSimulationMode.atOffice,
              'Office Desk (0m away)',
              'Simulates sitting at Bangalore office desk. Exactly 0m from office.',
              '< 200m (Valid)',
            ),
            const SizedBox(height: 16),
            RebsLook.button(
              label: 'Submit & Apply Simulation',
              icon: Icons.check_rounded,
              onPressed: () {
                _locationService.setSimulationMode(_selectedMode);
                if (context.mounted) Navigator.pop(context);
                Get.snackbar(
                  'Simulation Applied',
                  _selectedMode == LocationSimulationMode.realGps
                      ? 'Set to Current Location (Device GPS)'
                      : 'Set to Office Desk (0m away - Bangalore HQ)',
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
      );
    });
  }

  Widget _card(LocationSimulationMode mode, String title, String subtitle, String badge) {
    final selected = _selectedMode == mode;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => _selectedMode = mode),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? RebsLook.action : RebsLook.lineColor, width: selected ? 1.6 : 1),
          color: selected ? RebsLook.action.withValues(alpha: 0.06) : RebsLook.canvas,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge, style: TypeScale.body(size: 11, weight: FontWeight.w700, color: RebsLook.teal)),
            const SizedBox(height: 4),
            Text(title, style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor)),
            Text(subtitle, style: TypeScale.body(size: 12, weight: FontWeight.w400, color: RebsLook.muteColor)),
          ],
        ),
      ),
    );
  }
}
