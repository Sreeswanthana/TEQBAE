import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../data/models/attendance_event_model.dart';
import '../../../data/models/attendance_record_model.dart';
import '../controllers/dashboard_controller.dart';

class RecentAttendanceList extends StatelessWidget {
  const RecentAttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final _ = ThemeHelper.mode;
      final records = controller.recentRecords;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'RECENT ATTENDANCE',
                  style: TypeScale.body(size: 11, weight: FontWeight.w700, color: RebsLook.muteColor),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => Get.toNamed(Routes.history),
                  child: Text('View all', style: TypeScale.body(size: 13, weight: FontWeight.w700, color: ThemeHelper.primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: RebsLook.cardBox(border: RebsLook.lineColor.withValues(alpha: 0.9)),
              child: records.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      child: Text(
                        'No previous records yet',
                        textAlign: TextAlign.center,
                        style: TypeScale.body(size: 13, weight: FontWeight.w500, color: RebsLook.muteColor),
                      ),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < records.length; i++) ...[
                          _Row(item: records[i]),
                          if (i < records.length - 1) Divider(height: 1, indent: 52, color: RebsLook.lineColor),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item});
  final AttendanceRecordModel item;

  @override
  Widget build(BuildContext context) {
    DateTime? parsed;
    try {
      parsed = DateTime.parse(item.date);
    } catch (_) {}
    final dateLabel = parsed != null ? DateFormat('dd MMM yyyy').format(parsed) : item.date;
    final time = DateFormat('hh:mm a');
    final inn = item.checkInTime != null ? time.format(item.checkInTime!) : null;
    final out = item.checkOutTime != null ? time.format(item.checkOutTime!) : null;
    final synced = item.syncStatus == SyncStatus.synced;
    final mark = synced ? RebsLook.success : (item.syncStatus == SyncStatus.pending ? RebsLook.amber : RebsLook.rose);
    final statusNote = switch (item.syncStatus) {
      SyncStatus.pending => 'Pending',
      SyncStatus.rejected => 'Rejected',
      SyncStatus.synced => '',
    };
    final completed = item.status == AttendanceStatus.checkedOut;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: mark.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: mark.withValues(alpha: 0.35)),
            ),
            child: Icon(
              completed ? Icons.check_rounded : Icons.schedule_rounded,
              size: 17,
              color: mark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateLabel, style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor)),
                if (inn != null)
                  Text(
                    out != null ? 'In $inn · Out $out' : 'Check-in $inn',
                    style: TypeScale.body(size: 11, weight: FontWeight.w500, color: RebsLook.muteColor),
                  ),
              ],
            ),
          ),
          if (statusNote.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(statusNote, style: TypeScale.body(size: 10, weight: FontWeight.w800, color: mark)),
            )
          else if (inn != null)
            Text(
              time.format(item.checkInTime!).toUpperCase(),
              style: TypeScale.body(size: 12, weight: FontWeight.w700, color: RebsLook.muteColor),
            ),
        ],
      ),
    );
  }
}