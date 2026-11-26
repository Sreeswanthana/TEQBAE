import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../data/models/attendance_event_model.dart';
import '../../../data/models/attendance_record_model.dart';
import '../controllers/dashboard_controller.dart';

class LiveWorkTimerCard extends StatelessWidget {
  const LiveWorkTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final _ = ThemeHelper.mode;
      final today = controller.todayRecord.value;
      final status = today?.status ?? AttendanceStatus.notCheckedIn;
      final timeFormat = DateFormat('hh:mm a');
      final inTime = today?.checkInTime != null ? timeFormat.format(today!.checkInTime!) : null;
      final clock = controller.formatDuration(controller.elapsedDuration.value);
      final pending = today?.syncStatus == SyncStatus.pending;
      final rejected = today?.syncStatus == SyncStatus.rejected;

      final title = switch (status) {
        AttendanceStatus.checkedIn => 'Checked in',
        AttendanceStatus.checkedOut => 'Shift completed',
        AttendanceStatus.notCheckedIn => 'Not checked in',
      };
      final tone = status == AttendanceStatus.notCheckedIn ? RebsLook.muteColor : RebsLook.success;
      final note = switch (status) {
        AttendanceStatus.checkedOut => 'Great work today. See you tomorrow.',
        AttendanceStatus.checkedIn => 'You are on the clock. Check out when you leave.',
        AttendanceStatus.notCheckedIn => 'Tap check-in when you reach the office.',
      };
      final link = status == AttendanceStatus.checkedIn ? 'Open check-out' : 'Open check-in';

      final loc = controller.currentLocation.value;
      final fetching = controller.isFetchingLocation.value;
      final inside = loc != null && loc.isWithinGeofence;
      final meters = loc?.distanceMeters?.round();
      final place = fetching
          ? 'Acquiring GPS coordinates…'
          : (meters == null ? 'Location not available' : (inside ? 'Within office geofence' : 'Outside office area'));

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: RebsLook.cardBox(border: RebsLook.lineColor.withValues(alpha: 0.9)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  "TODAY'S ATTENDANCE",
                  style: TypeScale.body(size: 11, weight: FontWeight.w700, color: RebsLook.muteColor, height: 1),
                ),
                const Spacer(),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: tone.withValues(alpha: 0.85), width: 2.5),
                    color: tone.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: BrandIcon(
                      switch (status) {
                        AttendanceStatus.checkedOut => BrandArt.trophy,
                        AttendanceStatus.checkedIn => BrandArt.check,
                        AttendanceStatus.notCheckedIn => BrandArt.clock,
                      },
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TypeScale.body(size: 18, weight: FontWeight.w800, color: tone, height: 1.1)),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (inTime != null)
                            Text(
                              inTime,
                              style: TypeScale.body(size: 13, weight: FontWeight.w600, color: RebsLook.muteColor),
                            ),
                          if (inTime != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text('·', style: TextStyle(color: RebsLook.muteColor.withValues(alpha: 0.6))),
                            ),
                          ],
                          Text(
                            status == AttendanceStatus.notCheckedIn && inTime == null ? '00:00:00' : clock,
                            style: TypeScale.display(
                              20,
                              weight: FontWeight.w800,
                              color: RebsLook.inkColor,
                              height: 1,
                              tracking: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(note, style: TypeScale.body(size: 12, weight: FontWeight.w500, color: RebsLook.muteColor, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
            if (pending || rejected) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (pending ? RebsLook.amberBg : RebsLook.roseBg).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pending ? 'Pending sync' : 'Sync rejected',
                    style: TypeScale.body(size: 11, weight: FontWeight.w700, color: pending ? RebsLook.amber : RebsLook.rose),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ThemeHelper.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: RebsLook.lineColor.withValues(alpha: 0.7)),
              ),
              child: Row(
                children: [
                  Icon(Icons.place_outlined, size: 18, color: inside ? RebsLook.success : RebsLook.muteColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(place, style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.inkColor)),
                  ),
                  if (meters != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (inside ? RebsLook.success : RebsLook.rose).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatDistance(meters),
                        style: TypeScale.body(
                          size: 11,
                          weight: FontWeight.w800,
                          color: inside ? RebsLook.success : RebsLook.rose,
                        ),
                      ),
                    ),
                  IconButton(
                    tooltip: 'Refresh location',
                    visualDensity: VisualDensity.compact,
                    onPressed: fetching ? null : controller.fetchCurrentLocation,
                    icon: fetching
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: ThemeHelper.primaryColor),
                          )
                        : Icon(Icons.refresh_rounded, size: 18, color: RebsLook.muteColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                onPressed: () => _openAttendance(),
                style: FilledButton.styleFrom(
                  backgroundColor: ThemeHelper.primaryColor,
                  foregroundColor: ThemeHelper.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  link,
                  style: TypeScale.body(size: 14, weight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _openAttendance() async {
    await Get.toNamed(Routes.attendance);
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboardData(isSilent: true);
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      AttendanceStatus.checkedIn => ('On shift', RebsLook.success.withValues(alpha: 0.12), RebsLook.success),
      AttendanceStatus.checkedOut => ('Done', RebsLook.muteColor.withValues(alpha: 0.15), RebsLook.muteColor),
      AttendanceStatus.notCheckedIn => ('Awaiting', RebsLook.amberBg, RebsLook.amber),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TypeScale.body(size: 10, weight: FontWeight.w800, color: fg, height: 1)),
    );
  }
}

String _formatDistance(int meters) {
  if (meters >= 1000) {
    final km = meters / 1000;
    if (km >= 100) return '${km.round()} km';
    return '${km.toStringAsFixed(km >= 10 ? 0 : 1)} km';
  }
  return '$meters m';
}