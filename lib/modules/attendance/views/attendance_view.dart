import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/widgets/page_shimmer.dart';
import '../../../app/widgets/screen_frame.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/attendance_event_model.dart';
import '../../../data/models/attendance_record_model.dart';
import '../../../modules/dev_tools/views/dev_simulation_sheet.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      final today = controller.todayRecord.value;
      final status = today?.status ?? AttendanceStatus.notCheckedIn;
      final loc = controller.locationResult.value;
      final checking = controller.isCheckingLocation.value;
      final inside = loc != null && loc.isWithinGeofence;
      final officeLat = controller.locationService.currentOfficeLatitude.value;
      final officeLng = controller.locationService.currentOfficeLongitude.value;
      final userLat = loc?.latitude;
      final userLng = loc?.longitude;
      final distance = loc?.distanceMeters?.round();
      final title = switch (status) {
        AttendanceStatus.checkedIn => 'Check Out',
        AttendanceStatus.checkedOut => 'Today',
        AttendanceStatus.notCheckedIn => 'Check In',
      };

      return Scaffold(
        backgroundColor: RebsLook.canvas,
        body: Stack(
          children: [
            const Positioned(top: -40, right: -30, child: _Blob(size: 150, color: Color(0xFFD7E8FF))),
            const Positioned(bottom: -20, left: -40, right: -20, child: _BottomWave()),
            SafeArea(
              child: ScreenFrame(
              child: Column(
                children: [
                  _Bar(
                    title: title,
                    onBack: () => Get.back(),
                    onSend: () => DevSimulationSheet.show(context),
                  ),
                  Expanded(
                    child: controller.isLoading.value
                        ? const AttendancePageShimmer()
                        : ListView(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                      children: [
                        _Hero(status: status, inTime: today?.checkInTime, outTime: today?.checkOutTime),
                        const SizedBox(height: 16),
                        _OfficeCard(
                          lat: officeLat,
                          lng: officeLng,
                          inside: inside,
                          checking: checking,
                        ),
                        if (!inside && !checking) ...[
                          const SizedBox(height: 8),
                          Text(
                            loc?.errorMessage ??
                                'You are ${distance ?? 0}m away from the office. Check-in is permitted only within 200m.',
                            style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
                          ),
                        ],
                        const SizedBox(height: 14),
                        _MapCard(
                          office: LatLng(officeLat, officeLng),
                          user: (userLat != null && userLng != null) ? LatLng(userLat, userLng) : null,
                          onRefresh: controller.verifyLocation,
                        ),
                        const SizedBox(height: 18),
                        if (status == AttendanceStatus.notCheckedIn)
                          _PunchButton(
                            label: 'Check In',
                            busy: controller.isSubmitting.value,
                            onPressed: controller.checkIn,
                          )
                        else if (status == AttendanceStatus.checkedIn)
                          _PunchButton(
                            label: 'Check Out',
                            busy: controller.isSubmitting.value,
                            onPressed: controller.checkOut,
                          )
                        else
                          const _DoneBanner(),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton.icon(
                            onPressed: checking ? null : controller.verifyLocation,
                            icon: checking
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: RebsLook.action),
                                  )
                                : Icon(Icons.refresh_rounded, size: 18, color: RebsLook.action),
                            label: Text(
                              'Refresh Location',
                              style: TypeScale.body(size: 14, weight: FontWeight.w600, color: RebsLook.action),
                            ),
                          ),
                        ),
                        if (!inside)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                controller.locationService.setSimulationMode(LocationSimulationMode.atOffice);
                                controller.verifyLocation();
                              },
                              child: const Text('Simulate Office Desk (0m)'),
                            ),
                          ),
                        if (today?.syncStatus == SyncStatus.pending)
                          Text(
                            'Pending Sync',
                            textAlign: TextAlign.center,
                            style: TypeScale.body(size: 12, weight: FontWeight.w700, color: RebsLook.amber),
                          ),
                        Center(
                          child: TextButton(
                            onPressed: () => _confirmReset(context),
                            child: Text(
                              'Reset Attendance (Test Again)',
                              style: TypeScale.body(size: 12, weight: FontWeight.w500, color: RebsLook.muteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmReset(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: RebsLook.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset today', style: TypeScale.display(22, color: RebsLook.inkColor)),
              const SizedBox(height: 6),
              Text(
                'This clears today’s record so check-in can be tested again.',
                style: TypeScale.body(size: 13, weight: FontWeight.w400, color: RebsLook.muteColor),
              ),
              const SizedBox(height: 16),
              RebsLook.button(
                label: 'Reset Attendance (Test Again)',
                onPressed: () {
                  Navigator.pop(ctx);
                  controller.resetTodayAttendance();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.title, required this.onBack, required this.onSend});
  final String title;
  final VoidCallback onBack;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TypeScale.body(size: 20, weight: FontWeight.w700, color: RebsLook.inkColor),
            ),
          ),
          _CircleButton(icon: Icons.send_rounded, onTap: onSend, tint: RebsLook.action),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap, this.tint});
  final IconData icon;
  final VoidCallback onTap;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RebsLook.card,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: const Color(0x22000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: tint ?? RebsLook.inkColor),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.status, required this.inTime, required this.outTime});
  final AttendanceStatus status;
  final DateTime? inTime;
  final DateTime? outTime;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('hh:mm a');
    final (lead, accent, body) = switch (status) {
      AttendanceStatus.checkedIn => (
          "You're On",
          'The Clock!',
          inTime == null
              ? 'Check out when you leave the office.'
              : 'Checked in at ${format.format(inTime!)}. Check out to close the day.',
        ),
      AttendanceStatus.checkedOut => (
          'Workday',
          'Complete',
          outTime == null ? 'Today’s attendance is saved.' : 'Checked out at ${format.format(outTime!)}.',
        ),
      AttendanceStatus.notCheckedIn => (
          "Let's Start",
          'Your Workday!',
          'Check in to mark your attendance for today.',
        ),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PinArt(status: status),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lead, style: TypeScale.display(22, color: RebsLook.inkColor, tracking: -0.4)),
              Text(accent, style: TypeScale.display(22, color: RebsLook.action, tracking: -0.4)),
              const SizedBox(height: 6),
              Text(body, style: TypeScale.body(size: 13, weight: FontWeight.w400, color: RebsLook.muteColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PinArt extends StatelessWidget {
  const _PinArt({required this.status});
  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final hero = switch (status) {
      AttendanceStatus.checkedOut => BrandArt.thumbs,
      AttendanceStatus.checkedIn => BrandArt.clock,
      AttendanceStatus.notCheckedIn => BrandArt.pin,
    };
    return SizedBox(
      width: 132,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(left: 0, bottom: 8, child: BrandIcon(BrandArt.office, size: 52)),
          BrandIcon(hero, size: status == AttendanceStatus.notCheckedIn ? 108 : 96),
          if (status == AttendanceStatus.checkedIn)
            const Positioned(right: 0, top: 8, child: BrandIcon(BrandArt.check, size: 32)),
          if (status == AttendanceStatus.checkedOut)
            const Positioned(right: 0, top: 4, child: BrandIcon(BrandArt.trophy, size: 36)),
        ],
      ),
    );
  }
}

class _OfficeCard extends StatelessWidget {
  const _OfficeCard({
    required this.lat,
    required this.lng,
    required this.inside,
    required this.checking,
  });

  final double lat;
  final double lng;
  final bool inside;
  final bool checking;

  @override
  Widget build(BuildContext context) {
    final pillBg = inside ? const Color(0xFFE5F8EC) : const Color(0xFFFDECEC);
    final pillFg = inside ? const Color(0xFF1F9D55) : RebsLook.rose;
    final pill = checking ? 'Locating' : (inside ? 'Within\n200m' : 'Outside\n200m');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: RebsLook.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RebsLook.lineColor),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0C3F73).withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: RebsLook.fieldFill, borderRadius: BorderRadius.circular(10)),
            child: const BrandIcon(BrandArt.office, size: 26),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Office Location', style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.inkColor)),
                Text(
                  'Lat: ${lat.toStringAsFixed(4)}, Long: ${lng.toStringAsFixed(4)}',
                  style: TypeScale.body(size: 12, weight: FontWeight.w400, color: RebsLook.muteColor),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: RebsLook.lineColor),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: pillBg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                inside
                    ? const BrandIcon(BrandArt.check, size: 18)
                    : Icon(Icons.cancel_rounded, size: 16, color: pillFg),
                const SizedBox(width: 4),
                Text(pill, style: TypeScale.body(size: 11, weight: FontWeight.w700, color: pillFg, height: 1.15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.office, required this.user, required this.onRefresh});
  final LatLng office;
  final LatLng? user;
  final VoidCallback onRefresh;

  bool get _nativeMap {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: Responsive.mapHeight(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: _nativeMap
                  ? _GooglePunchMap(office: office, user: user)
                  : const ColoredBox(
                      color: Color(0xFFE7F0E4),
                      child: Center(child: BrandIcon(BrandArt.map, size: 120)),
                    ),
            ),
            if (user != null)
              const Positioned(
                left: 12,
                bottom: 12,
                child: _MapChip(icon: Icons.place_rounded, label: 'You are here'),
              ),
            Positioned(
              right: 12,
              top: 12,
              child: Material(
                color: RebsLook.card,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRefresh,
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(Icons.my_location_rounded, size: 18, color: RebsLook.inkColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: RebsLook.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: RebsLook.action),
          const SizedBox(width: 4),
          Text(label, style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.inkColor)),
        ],
      ),
    );
  }
}

class _GooglePunchMap extends StatefulWidget {
  const _GooglePunchMap({required this.office, required this.user});
  final LatLng office;
  final LatLng? user;

  @override
  State<_GooglePunchMap> createState() => _GooglePunchMapState();
}

class _GooglePunchMapState extends State<_GooglePunchMap> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant _GooglePunchMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.office != widget.office || oldWidget.user != widget.user) {
      _frame();
    }
  }

  Future<void> _frame() async {
    final map = _controller;
    if (map == null) return;
    final user = widget.user;
    if (user == null) {
      await map.animateCamera(CameraUpdate.newLatLngZoom(widget.office, 16));
      return;
    }
    final meters = Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      widget.office.latitude,
      widget.office.longitude,
    );
    if (meters < 40) {
      await map.animateCamera(CameraUpdate.newLatLngZoom(user, 17));
      return;
    }
    final south = user.latitude < widget.office.latitude ? user.latitude : widget.office.latitude;
    final north = user.latitude > widget.office.latitude ? user.latitude : widget.office.latitude;
    final west = user.longitude < widget.office.longitude ? user.longitude : widget.office.longitude;
    final east = user.longitude > widget.office.longitude ? user.longitude : widget.office.longitude;
    try {
      await map.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east)),
          56,
        ),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('office'),
        position: widget.office,
        infoWindow: InfoWindow(title: 'Office', snippet: AppConstants.defaultOfficeName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      if (user != null)
        Marker(
          markerId: const MarkerId('you'),
          position: user,
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: user ?? widget.office, zoom: 16),
      markers: markers,
      circles: {
        Circle(
          circleId: const CircleId('geofence'),
          center: widget.office,
          radius: AppConstants.maxAllowedDistanceMeters,
          fillColor: const Color(0x332F6BFF),
          strokeColor: const Color(0x662F6BFF),
          strokeWidth: 1,
        ),
      },
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      onMapCreated: (c) {
        _controller = c;
        _frame();
      },
    );
  }
}

class _PunchButton extends StatelessWidget {
  const _PunchButton({required this.label, required this.busy, required this.onPressed});
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Responsive.buttonHeight(context),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: RebsLook.action,
          foregroundColor: RebsLook.onAction,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: TypeScale.body(size: 16, weight: FontWeight.w700, color: RebsLook.onAction),
        ),
        onPressed: busy ? null : onPressed,
        child: busy
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: RebsLook.onAction))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 22),
                  const SizedBox(width: 8),
                  Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
      ),
    );
  }
}

class _DoneBanner extends StatelessWidget {
  const _DoneBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFFE5F8EC), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          const BrandIcon(BrandArt.trophy, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Great Work! Today’s shift is complete.',
              style: TypeScale.body(size: 14, weight: FontWeight.w700, color: const Color(0xFF146C3A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _BottomWave extends StatelessWidget {
  const _BottomWave();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: 90,
        child: CustomPaint(painter: _WavePainter()),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD6E8FF);
    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.35, size.height, size.width * 0.7, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.1, size.width, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFEEF5FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
