import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/app_drawer.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../app/widgets/chrome_actions.dart';
import '../../../app/widgets/page_shimmer.dart';
import '../../../app/widgets/screen_frame.dart';
import '../../../data/models/attendance_event_model.dart';
import '../../../data/models/attendance_record_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      return Scaffold(
        extendBody: true,
        backgroundColor: RebsLook.canvas,
        drawer: const AppDrawer(),
        appBar: const RebsAppBar(title: 'Attendance History', actions: [ChromeActions()]),
        body: ScreenFrame(
          child: Column(
          children: [
            const _Filters(),
            Expanded(
              child: controller.isLoading.value
                  ? const HistoryPageShimmer()
                  : controller.filteredRecords.isEmpty
                      ? _Empty(filter: controller.selectedFilter.value)
                      : RefreshIndicator(
                          color: RebsLook.action,
                          onRefresh: controller.loadHistory,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                            itemCount: controller.filteredRecords.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (_, index) => _Card(record: controller.filteredRecords[index]),
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

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    const filters = ['All', 'Synced', 'Pending', 'Rejected'];
    return Obx(() {
      final active = controller.selectedFilter.value;
      return SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final f = filters[i];
            final selected = active == f;
            return ChoiceChip(
              label: Text(f),
              selected: selected,
              showCheckmark: false,
              labelStyle: TypeScale.body(
                size: 12,
                weight: FontWeight.w700,
                color: selected ? RebsLook.onAction : RebsLook.inkColor,
              ),
              selectedColor: RebsLook.action,
              backgroundColor: RebsLook.card,
              side: BorderSide(color: selected ? RebsLook.action : RebsLook.lineColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (_) => controller.setFilter(f),
            );
          },
        ),
      );
    });
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.record});
  final AttendanceRecordModel record;

  @override
  Widget build(BuildContext context) {
    DateTime? parsed;
    try {
      parsed = DateTime.parse(record.date);
    } catch (_) {}
    final date = parsed != null ? DateFormat('dd MMM yyyy').format(parsed) : record.date;
    final time = DateFormat('hh:mm a');
    final inn = record.checkInTime != null ? time.format(record.checkInTime!) : '--:--';
    final out = record.checkOutTime != null ? time.format(record.checkOutTime!) : '--:--';
    final (label, fg, bg) = switch (record.syncStatus) {
      SyncStatus.pending => ('Pending', RebsLook.amber, RebsLook.amberBg),
      SyncStatus.rejected => ('Rejected', RebsLook.rose, RebsLook.roseBg),
      SyncStatus.synced => ('Synced', RebsLook.green, RebsLook.mint),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RebsLook.cardBox(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: BrandIcon(
                  record.syncStatus == SyncStatus.pending ? BrandArt.sync : BrandArt.calendarCheck,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date, style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor)),
                    Text(
                      'In $inn   •   Out $out',
                      style: TypeScale.body(size: 12, weight: FontWeight.w400, color: RebsLook.muteColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                child: Text(label, style: TypeScale.body(size: 11, weight: FontWeight.w700, color: fg)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Duration  ${record.formattedWorkingHours}',
            style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.action),
          ),
          if (record.rejectionReason != null && record.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Rejection reason: ${record.rejectionReason}',
              style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
            ),
          ],
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.filter});
  final String filter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandIcon(BrandArt.document, size: 56),
            const SizedBox(height: 8),
            Text('No Attendance Records', style: TypeScale.body(size: 16, weight: FontWeight.w700, color: RebsLook.inkColor)),
            const SizedBox(height: 4),
            Text(
              'No records match the current filter ($filter).',
              textAlign: TextAlign.center,
              style: TypeScale.body(size: 13, weight: FontWeight.w400, color: RebsLook.muteColor),
            ),
          ],
        ),
      ),
    );
  }
}
