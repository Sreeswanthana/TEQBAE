import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/theme/type_scale.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/sync_service.dart';

class SyncBannerWidget extends StatelessWidget {
  const SyncBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityService>();
    final syncService = Get.find<SyncService>();

    return Obx(() {
      final isOnline = connectivity.isOnline.value;
      final pendingCount = syncService.pendingCount.value;
      final isSyncing = syncService.isSyncing.value;

      if (isOnline && pendingCount == 0) {
        return const SizedBox.shrink();
      }

      final offline = !isOnline;
      final tone = offline ? AppColors.errorRed : const Color(0xFF92400E);
      final bg = offline ? const Color(0xFFFFF4F4) : RebsLook.amberBg;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: BrandIcon(offline ? BrandArt.offline : BrandArt.sync, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offline ? 'Offline Workspace Active' : '$pendingCount Pending Record(s) to Sync',
                    style: TypeScale.body(size: 13, weight: FontWeight.w700, color: tone),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    offline
                        ? 'Attendance actions will be saved locally and synced once online.'
                        : 'Local attendance saved. Tap Sync Now to commit to server.',
                    style: TypeScale.body(size: 11, weight: FontWeight.w400, color: const Color(0xFF57534E)),
                  ),
                ],
              ),
            ),
            if (pendingCount > 0 && isOnline)
              TextButton(
                onPressed: isSyncing ? null : () => syncService.syncPendingQueue(),
                child: isSyncing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: RebsLook.action),
                      )
                    : Text('Sync Now', style: TypeScale.body(size: 12, weight: FontWeight.w700, color: RebsLook.action)),
              ),
          ],
        ),
      );
    });
  }
}
