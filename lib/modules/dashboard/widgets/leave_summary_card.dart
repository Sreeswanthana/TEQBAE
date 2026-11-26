import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../data/models/leave_balance_model.dart';
import '../controllers/dashboard_controller.dart';

class LeaveSummaryCard extends StatelessWidget {
  const LeaveSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final _ = ThemeHelper.mode;
      final balance = controller.leaveBalance.value;
      final casual = balance?.availableCasual ?? 0.0;
      final sick = balance?.availableSick ?? 0.0;
      final total = balance?.totalAvailable ?? 0.0;
      final share = total <= 0 ? 0.0 : (casual / total).clamp(0.0, 1.0);

      final ink = ThemeHelper.onPrimary;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeHelper.primaryColor,
              Color.lerp(ThemeHelper.primaryColor, RebsLook.teal, 0.35)!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeHelper.primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: BrandIcon(BrandArt.beach, size: 28)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEAVE BALANCE',
                        style: TypeScale.body(size: 10, weight: FontWeight.w700, color: ink.withValues(alpha: 0.75)),
                      ),
                      Text(
                        '${LeaveBalanceModel.format(total)} days',
                        style: TypeScale.display(24, weight: FontWeight.w800, color: ink, tracking: -0.5, height: 1.05),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: ink,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => Get.toNamed(Routes.leave),
                  child: Text('Details', style: TypeScale.body(size: 13, weight: FontWeight.w700, color: ink)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 7,
                child: Row(
                  children: [
                    Expanded(flex: (share * 100).round().clamp(1, 99), child: ColoredBox(color: ink)),
                    Expanded(
                      flex: (100 - (share * 100).round()).clamp(1, 99),
                      child: ColoredBox(color: ink.withValues(alpha: 0.28)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _LeaveTypeChip(label: 'Casual', value: LeaveBalanceModel.format(casual), ink: ink)),
                const SizedBox(width: 10),
                Expanded(child: _LeaveTypeChip(label: 'Sick', value: LeaveBalanceModel.format(sick), ink: ink, dimmed: true)),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _LeaveTypeChip extends StatelessWidget {
  const _LeaveTypeChip({required this.label, required this.value, required this.ink, this.dimmed = false});

  final String label;
  final String value;
  final Color ink;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ink.withValues(alpha: dimmed ? 0.1 : 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ink.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TypeScale.body(size: 11, weight: FontWeight.w600, color: ink.withValues(alpha: 0.85))),
          ),
          Text('$value d', style: TypeScale.body(size: 14, weight: FontWeight.w800, color: ink)),
        ],
      ),
    );
  }
}