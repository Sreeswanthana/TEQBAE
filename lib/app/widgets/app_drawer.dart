import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/location_service.dart';
import '../../modules/attendance/controllers/attendance_controller.dart';
import '../../modules/auth/controllers/login_controller.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/dev_tools/views/theme_helper_sheet.dart';
import '../routes/app_routes.dart';
import '../theme/rebs_look.dart';
import '../theme/theme_helper.dart';
import '../theme/type_scale.dart';
import 'brand_art.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      final locService = Get.isRegistered<LocationService>() ? Get.find<LocationService>() : null;
      final simMode = locService?.simulationMode.value ?? LocationSimulationMode.realGps;
      final currentRoute = Get.currentRoute;

      return Drawer(
        backgroundColor: RebsLook.canvas,
        shape: const RoundedRectangleBorder(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: RebsLook.headerGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: BrandIcon(BrandArt.user, size: 34),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: const BrandIcon(BrandArt.briefcase, size: 22),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: const BrandIcon(BrandArt.gear, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Sree Swanthana', style: TypeScale.body(size: 18, weight: FontWeight.w700, color: Colors.white)),
                    Text('intest@123  •  REBS-2024-042', style: TypeScale.body(size: 12, weight: FontWeight.w500, color: Colors.white70)),
                    Text('Software Engineer  •  Engineering', style: TypeScale.body(size: 12, weight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                      'Bengaluru HQ (Fixed 200m Geofence)',
                      style: TypeScale.body(size: 11, weight: FontWeight.w500, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _label('Display'),
                    _tile('Light', ThemeHelper.isLight, () => ThemeHelper.setTheme(AppThemeMode.light)),
                    _tile('Dark', ThemeHelper.isDark, () => ThemeHelper.setTheme(AppThemeMode.dark)),
                    _tile('Eye Care', ThemeHelper.isEyeComfort, () => ThemeHelper.setTheme(AppThemeMode.eyeComfort)),
                    _tile('Display Mode Settings', false, () {
                      Navigator.pop(context);
                      ThemeHelperSheet.show(context);
                    }),
                    _label('Reviewer location'),
                    _tile(
                      'Office Desk (0m away)',
                      simMode == LocationSimulationMode.atOffice,
                      () {
                        locService?.setSimulationMode(LocationSimulationMode.atOffice);
                        _refresh();
                      },
                      subtitle: 'Simulate inside Bangalore office geofence',
                    ),
                    _tile(
                      'Real Device GPS',
                      simMode == LocationSimulationMode.realGps,
                      () {
                        locService?.setSimulationMode(LocationSimulationMode.realGps);
                        _refresh();
                      },
                      subtitle: 'Acquire real-time coordinates from device',
                    ),
                    _label('Navigate'),
                    _tile('Dashboard', currentRoute == Routes.dashboard || currentRoute == '/', () {
                      Navigator.pop(context);
                      if (currentRoute != Routes.dashboard && currentRoute != '/') {
                        Get.offAllNamed(Routes.dashboard);
                      }
                    }),
                    _tile('Attendance Check-In / Out', currentRoute == Routes.attendance, () async {
                      Navigator.pop(context);
                      if (currentRoute != Routes.attendance) {
                        await Get.toNamed(Routes.attendance);
                        if (Get.isRegistered<DashboardController>()) {
                          Get.find<DashboardController>().loadDashboardData(isSilent: true);
                        }
                      }
                    }),
                    _tile('Attendance History', currentRoute == Routes.history, () {
                      Navigator.pop(context);
                      if (currentRoute != Routes.history) Get.toNamed(Routes.history);
                    }),
                    _tile('Leave Management', currentRoute == Routes.leave, () {
                      Navigator.pop(context);
                      if (currentRoute != Routes.leave) Get.toNamed(Routes.leave);
                    }),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: RebsLook.rose),
                title: Text('Sign Out Session', style: TypeScale.body(size: 14, weight: FontWeight.w700, color: RebsLook.rose)),
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _confirmSignOut(BuildContext context) {
    Navigator.pop(context);
    Get.dialog(
      AlertDialog(
        backgroundColor: RebsLook.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out', style: TypeScale.display(22, color: RebsLook.inkColor)),
        content: Text(
          'Are you sure you want to sign out of REBS HRMS?',
          style: TypeScale.body(size: 13, weight: FontWeight.w400, color: RebsLook.muteColor),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: RebsLook.rose,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              LoginController.logout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _refresh() {
    if (Get.isRegistered<AttendanceController>()) {
      Get.find<AttendanceController>().verifyLocation();
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchCurrentLocation();
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Text(text, style: TypeScale.body(size: 12, weight: FontWeight.w700, color: RebsLook.muteColor)),
    );
  }

  Widget _tile(String title, bool selected, VoidCallback onTap, {String? subtitle}) {
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      selected: selected,
      selectedTileColor: RebsLook.action.withValues(alpha: 0.08),
      title: Text(
        title,
        style: TypeScale.body(
          size: 14,
          weight: selected ? FontWeight.w700 : FontWeight.w600,
          color: selected ? RebsLook.action : RebsLook.inkColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: TypeScale.body(size: 11, weight: FontWeight.w400, color: RebsLook.muteColor)),
      trailing: selected ? Icon(Icons.check_rounded, color: RebsLook.action, size: 18) : null,
      onTap: onTap,
    );
  }
}
