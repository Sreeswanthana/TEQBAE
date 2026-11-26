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
import '../../../data/models/leave_balance_model.dart';
import '../../../data/models/leave_request_model.dart';
import '../controllers/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      return AnimatedBuilder(
        animation: controller.tabController,
        builder: (context, _) {
          final history = controller.tabController.index == 1;
          return Scaffold(
            extendBody: true,
            backgroundColor: RebsLook.canvas,
            drawer: const AppDrawer(),
            appBar: RebsAppBar(
              title: history ? 'My Leave Requests' : 'Apply Leave',
              actions: const [ChromeActions()],
            ),
            body: ScreenFrame(
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      _tab('Apply Leave', 0),
                      const SizedBox(width: 8),
                      _tab('My Leave Requests', 1),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: const [
                      _ApplyTab(),
                      _HistoryTab(),
                    ],
                  ),
                ),
              ],
              ),
            ),
            bottomNavigationBar: const RebsDock(),
          );
        },
      );
    });
  }

  Widget _tab(String label, int index) {
    final selected = controller.tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.tabController.animateTo(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? RebsLook.action : RebsLook.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? RebsLook.action : RebsLook.lineColor),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TypeScale.body(
              size: 12,
              weight: FontWeight.w700,
              color: selected ? RebsLook.onAction : RebsLook.inkColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ApplyTab extends GetView<LeaveController> {
  const _ApplyTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LeaveApplyShimmer();
      }
      final balance = controller.leaveBalance.value;
      final casual = balance?.availableCasual ?? 0.0;
      final sick = balance?.availableSick ?? 0.0;
      final type = controller.selectedLeaveType.value;
      final day = controller.selectedDayType.value;
      final requested = controller.calculatedDaysCount;
      final available = type == LeaveType.casual ? casual : sick;
      final over = requested > available;
      final chars = controller.reasonLength.value;
      final online = controller.connectivityService.isOnline.value;

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
        children: [
          if (!online)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: RebsLook.roseBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const BrandIcon(BrandArt.offline, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Device is offline. Leave submission requires an active network connection.',
                      style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(child: _typePill('Casual', '${LeaveBalanceModel.format(casual)} left', type == LeaveType.casual, () {
                controller.selectedLeaveType.value = LeaveType.casual;
              }, art: BrandArt.beach)),
              const SizedBox(width: 10),
              Expanded(child: _typePill('Sick', '${LeaveBalanceModel.format(sick)} left', type == LeaveType.sick, () {
                controller.selectedLeaveType.value = LeaveType.sick;
              }, art: BrandArt.calendarClock)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _typePill('Full Day', '1.0d', day == LeaveDayType.fullDay, () => controller.setDayType(LeaveDayType.fullDay))),
              const SizedBox(width: 8),
              Expanded(child: _typePill('First Half', '0.5d', day == LeaveDayType.firstHalf, () => controller.setDayType(LeaveDayType.firstHalf))),
              const SizedBox(width: 8),
              Expanded(child: _typePill('Second Half', '0.5d', day == LeaveDayType.secondHalf, () => controller.setDayType(LeaveDayType.secondHalf))),
            ],
          ),
          const SizedBox(height: 14),
          if (day == LeaveDayType.fullDay)
            Row(
              children: [
                Expanded(child: _dateBox(context, 'Start Date', controller.startDate.value, controller.setStartDate)),
                const SizedBox(width: 10),
                Expanded(
                  child: _dateBox(
                    context,
                    'End Date',
                    controller.endDate.value,
                    controller.setEndDate,
                    minDate: controller.startDate.value,
                  ),
                ),
              ],
            )
          else
            _dateBox(context, 'Leave Date', controller.startDate.value, controller.setStartDate),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Reason', style: TypeScale.body(size: 13, weight: FontWeight.w600, color: RebsLook.muteColor)),
              const Spacer(),
              Text(
                '$chars / 10 chars min',
                style: TypeScale.body(
                  size: 12,
                  weight: FontWeight.w700,
                  color: chars >= 10 ? RebsLook.success : RebsLook.muteColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.reasonController,
            maxLines: 3,
            style: TypeScale.body(size: 14, weight: FontWeight.w500, color: RebsLook.inkColor),
            decoration: InputDecoration(
              hintText: 'Enter reason (minimum 10 non-whitespace characters)...',
              hintStyle: TypeScale.body(size: 13, weight: FontWeight.w400, color: RebsLook.muteColor),
              filled: true,
              fillColor: RebsLook.card,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: RebsLook.lineColor)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: RebsLook.lineColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: chars >= 10 ? RebsLook.success : RebsLook.action, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: RebsLook.cardBox(radius: 16),
            child: Row(
              children: [
                const BrandIcon(BrandArt.clipboard, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    day == LeaveDayType.fullDay
                        ? 'Requested Days: ${LeaveBalanceModel.format(requested)}\nAvailable Balance: ${LeaveBalanceModel.format(available)} Days'
                        : 'Total: 0.5 Day (${day.title})\n${day.timeSlot}',
                    style: TypeScale.body(
                      size: 12,
                      weight: FontWeight.w600,
                      color: over ? RebsLook.rose : RebsLook.inkColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (over)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Requested duration exceeds available balance!',
                style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
              ),
            ),
          const SizedBox(height: 16),
          RebsLook.button(
            label: 'Submit Request',
            icon: Icons.send_rounded,
            busy: controller.isSubmitting.value,
            onPressed: controller.submitLeaveApplication,
          ),
        ],
      );
    });
  }

  Widget _typePill(String title, String subtitle, bool selected, VoidCallback onTap, {String? art}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? RebsLook.action : RebsLook.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? RebsLook.action : RebsLook.lineColor),
        ),
        child: Column(
          children: [
            if (art != null) ...[
              BrandIcon(art, size: 26),
              const SizedBox(height: 4),
            ],
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TypeScale.body(size: 13, weight: FontWeight.w700, color: selected ? RebsLook.onAction : RebsLook.inkColor)),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TypeScale.body(size: 10, weight: FontWeight.w500, color: selected ? RebsLook.onAction : RebsLook.muteColor)),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(BuildContext context, String label, DateTime date, void Function(DateTime) onPicked, {DateTime? minDate}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final first = minDate ?? today;
        final initial = date.isBefore(first) ? first : date;
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: today.add(const Duration(days: 365)),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: RebsLook.cardBox(radius: 16, border: RebsLook.lineColor),
        child: Row(
          children: [
            const BrandIcon(BrandArt.calendarClock, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TypeScale.body(size: 11, weight: FontWeight.w500, color: RebsLook.muteColor)),
                  Text(DateFormat('dd MMM yyyy').format(date), style: TypeScale.body(size: 13, weight: FontWeight.w700, color: RebsLook.inkColor)),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: RebsLook.muteColor),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab();

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaveController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const LeaveHistoryShimmer();
      }
      final all = controller.leaveRequests.toList();
      final requests = all.where((r) {
        return switch (_filter) {
          'Pending' => r.status == LeaveStatus.pending,
          'Approved' => r.status == LeaveStatus.approved,
          'Rejected' => r.status == LeaveStatus.rejected,
          _ => true,
        };
      }).toList();

      return Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final f in ['All', 'Pending', 'Approved', 'Rejected'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: _filter == f,
                      showCheckmark: false,
                      labelStyle: TypeScale.body(
                        size: 12,
                        weight: FontWeight.w700,
                        color: _filter == f ? RebsLook.onAction : RebsLook.inkColor,
                      ),
                      selectedColor: RebsLook.action,
                      backgroundColor: RebsLook.card,
                      side: BorderSide(color: _filter == f ? RebsLook.action : RebsLook.lineColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: requests.isEmpty
                ? Center(
                    child: Text(
                      all.isEmpty ? 'You haven\'t applied for any leaves yet.' : 'No Leave Requests',
                      style: TypeScale.body(size: 14, weight: FontWeight.w600, color: RebsLook.muteColor),
                    ),
                  )
                : RefreshIndicator(
                    color: RebsLook.action,
                    onRefresh: controller.loadData,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _RequestCard(req: requests[i]),
                    ),
                  ),
          ),
        ],
      );
    });
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.req});
  final LeaveRequestModel req;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy');
    final half = req.dayType != LeaveDayType.fullDay;
    final (label, fg, bg) = switch (req.status) {
      LeaveStatus.approved => ('Approved', RebsLook.green, RebsLook.mint),
      LeaveStatus.rejected => ('Rejected', RebsLook.rose, RebsLook.roseBg),
      LeaveStatus.pending => ('Pending', RebsLook.amber, RebsLook.amberBg),
    };
    final when = half ? '${date.format(req.startDate)} (${req.dayType.timeSlot})' : '${date.format(req.startDate)} – ${date.format(req.endDate)}';

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
                  req.leaveType == LeaveType.casual ? BrandArt.beach : BrandArt.calendarClock,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  req.leaveType == LeaveType.casual ? 'Casual Leave' : 'Sick Leave',
                  style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor),
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
          Text(when, style: TypeScale.body(size: 12, weight: FontWeight.w500, color: RebsLook.muteColor)),
          Text(
            '${half ? req.dayType.title : 'Full Day'} (${LeaveBalanceModel.format(req.daysCount)}d)',
            style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.action),
          ),
          const SizedBox(height: 4),
          Text('Reason: ${req.reason}', style: TypeScale.body(size: 12, weight: FontWeight.w500, color: RebsLook.inkColor)),
          Text(
            'Applied on: ${DateFormat('dd MMM yyyy • hh:mm a').format(req.createdAt)}',
            style: TypeScale.body(size: 11, weight: FontWeight.w400, color: RebsLook.muteColor),
          ),
          if (req.rejectionReason != null && req.rejectionReason!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Rejection note: ${req.rejectionReason}',
                style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
              ),
            ),
        ],
      ),
    );
  }
}
