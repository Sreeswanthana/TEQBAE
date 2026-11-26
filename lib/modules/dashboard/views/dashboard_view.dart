import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/app_drawer.dart';
import '../../../app/widgets/page_shimmer.dart';
import '../../../app/widgets/screen_frame.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../core/services/sync_service.dart';
import '../../../data/models/attendance_record_model.dart';
import '../../dev_tools/views/dev_simulation_sheet.dart';
import '../../dev_tools/views/theme_helper_sheet.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/leave_summary_card.dart';
import '../widgets/live_work_timer_card.dart';
import '../widgets/recent_attendance_list.dart';
import '../widgets/sync_banner_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      return Scaffold(
        extendBody: true,
        backgroundColor: RebsLook.canvas,
        drawer: const AppDrawer(),
        body: ScreenFrame(
          child: controller.isLoading.value
            ? const DashboardShimmer()
            : (controller.errorMessage.isNotEmpty && controller.employee.value == null)
                ? _Error(message: controller.errorMessage.value, onRetry: () => controller.loadDashboardData(forceRefresh: true))
                : Column(
                    children: [
                      const _HomeHeader(),
                      Expanded(
                        child: RefreshIndicator(
                          color: RebsLook.action,
                          onRefresh: () => controller.loadDashboardData(forceRefresh: true),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 110),
                            children: const [
                              SyncBannerWidget(),
                              LiveWorkTimerCard(),
                              LeaveSummaryCard(),
                              _QuickActions(),
                              RecentAttendanceList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        bottomNavigationBar: const RebsDock(),
      );
    });
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final _ = ThemeHelper.mode;
      final emp = controller.employee.value;
      final pending = Get.isRegistered<SyncService>() ? Get.find<SyncService>().pendingCount.value : 0;
      return SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: RebsLook.card,
            border: Border(bottom: BorderSide(color: RebsLook.lineColor.withValues(alpha: 0.85))),
            boxShadow: RebsLook.light
                ? [BoxShadow(color: RebsLook.navy.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]
                : const [],
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (ctx) => _HeaderButton(
                  tooltip: 'Open Workspace Drawer',
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Icon(Icons.menu_rounded, color: RebsLook.inkColor, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              if (emp != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RebsLook.brandGradient,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RebsLook.light ? const Color(0xFFF8FBFF) : ThemeHelper.surfaceVariant,
                    ),
                    child: Center(
                      child: Text(
                        _initials(emp.name),
                        style: TypeScale.body(size: 15, weight: FontWeight.w800, color: RebsLook.inkColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: TypeScale.body(size: 11, weight: FontWeight.w600, color: RebsLook.muteColor, height: 1.2),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        emp.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TypeScale.body(size: 17, weight: FontWeight.w800, color: RebsLook.inkColor, height: 1.15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${emp.id}  ·  ${emp.role}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TypeScale.body(size: 12, weight: FontWeight.w500, color: RebsLook.muteColor, height: 1.2),
                      ),
                    ],
                  ),
                ),
              ] else
                const Spacer(),
              _HeaderButton(
                tooltip: 'Alerts',
                onTap: () => _openHeaderMenu(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications_none_rounded, color: RebsLook.inkColor, size: 22),
                    if (pending > 0)
                      const Positioned(
                        right: -1,
                        top: -1,
                        child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFEF4444)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final status = controller.todayRecord.value?.status ?? AttendanceStatus.notCheckedIn;
      final checkLabel = switch (status) {
        AttendanceStatus.checkedIn => 'Check Out',
        AttendanceStatus.checkedOut => 'Shift done',
        AttendanceStatus.notCheckedIn => 'Check In / Out',
      };
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(title: 'Quick actions'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: switch (status) {
                      AttendanceStatus.checkedIn => Icons.logout_rounded,
                      AttendanceStatus.checkedOut => Icons.verified_rounded,
                      AttendanceStatus.notCheckedIn => Icons.fingerprint_rounded,
                    },
                    label: checkLabel,
                    subtitle: 'Attendance',
                    accent: RebsLook.success,
                    tint: RebsLook.successBg,
                    onTap: () async {
                      await Get.toNamed(Routes.attendance);
                      if (Get.isRegistered<DashboardController>()) {
                        Get.find<DashboardController>().loadDashboardData(isSilent: true);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.event_available_rounded,
                    label: 'Apply leave',
                    subtitle: 'Time off',
                    accent: RebsLook.lilac,
                    tint: RebsLook.light ? RebsLook.lavender : RebsLook.fieldFill,
                    onTap: () => Get.toNamed(Routes.leave),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TypeScale.body(
            size: 11,
            weight: FontWeight.w700,
            color: RebsLook.muteColor,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: RebsLook.lineColor, height: 1)),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.tint,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RebsLook.card,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: RebsLook.lineColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [tint.withValues(alpha: RebsLook.light ? 0.55 : 0.35), RebsLook.card],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: RebsLook.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accent.withValues(alpha: 0.25)),
                    boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: TypeScale.body(size: 11, weight: FontWeight.w600, color: RebsLook.muteColor),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TypeScale.body(size: 14, weight: FontWeight.w800, color: RebsLook.inkColor, height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.child, required this.onTap, required this.tooltip});
  final Widget child;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: RebsLook.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: RebsLook.lineColor),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(width: 44, height: 44, child: Center(child: child)),
        ),
      ),
    );
  }
}

void _openHeaderMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: RebsLook.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.contrast, color: RebsLook.inkColor),
            title: Text('Display mode', style: TextStyle(color: RebsLook.inkColor)),
            onTap: () {
              Navigator.pop(ctx);
              ThemeHelperSheet.show(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.biotech_outlined, color: RebsLook.inkColor),
            title: Text('Location simulation', style: TextStyle(color: RebsLook.inkColor)),
            onTap: () {
              Navigator.pop(ctx);
              DevSimulationSheet.show(context);
            },
          ),
        ],
      ),
    ),
  );
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'RE';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandIcon(BrandArt.offline, size: 56),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TypeScale.body(size: 14, color: RebsLook.inkColor)),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
