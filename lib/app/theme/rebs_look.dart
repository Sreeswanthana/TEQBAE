import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../widgets/floating_bottom_nav.dart';
import '../widgets/screen_frame.dart';
import 'theme_helper.dart';
import 'type_scale.dart';

/// Visual system matched to the REBS HRMS reference screens.
class RebsLook {
  static const Color navy = Color(0xFF0C3F73);
  static const Color navyDeep = Color(0xFF082C52);
  static const Color teal = Color(0xFF14998A);
  static const Color sky = Color(0xFFF4F8FC);
  static const Color ink = Color(0xFF17324C);
  static const Color mute = Color(0xFF6D7F93);
  static const Color line = Color(0xFFE4EDF5);
  static const Color mint = Color(0xFFE7F8EE);
  static const Color green = Color(0xFF1F9D55);
  static const Color lavender = Color(0xFFEDE7FF);
  static const Color lilac = Color(0xFF6E62B6);
  static const Color amberBg = Color(0xFFFFF6E4);
  static const Color amber = Color(0xFFE39B12);
  static const Color roseBg = Color(0xFFFDECEC);
  static const Color rose = Color(0xFFE15555);

  static bool get light => ThemeHelper.isLight;
  static bool get night => ThemeHelper.isDark;

  static Color get canvas {
    if (ThemeHelper.isEyeComfort) return ThemeHelper.background;
    if (night) return const Color(0xFF071833);
    return const Color(0xFFF4F8FC);
  }

  static Color get card {
    if (ThemeHelper.isEyeComfort) return ThemeHelper.cardColor;
    if (night) return const Color(0xFF0E2A52);
    return Colors.white;
  }

  static Color get inkColor {
    if (night || ThemeHelper.isEyeComfort) return ThemeHelper.textPrimary;
    return const Color(0xFF0B2A6F);
  }

  static Color get muteColor {
    if (night) return const Color(0xFF9BB4D4);
    if (ThemeHelper.isEyeComfort) return ThemeHelper.textSecondary;
    return const Color(0xFF6D7F93);
  }

  static Color get lineColor {
    if (night) return const Color(0xFF1E4578);
    if (ThemeHelper.isEyeComfort) return ThemeHelper.cardBorder;
    return const Color(0xFFE4EDF6);
  }

  static Color get action {
    if (ThemeHelper.isEyeComfort) return ThemeHelper.primaryColor;
    return const Color(0xFF1E5BD8);
  }

  static Color get onAction {
    if (ThemeHelper.isEyeComfort) return ThemeHelper.onPrimary;
    return Colors.white;
  }

  static Color get fieldFill {
    if (light) return const Color(0xFFF3F6FB);
    if (night) return const Color(0xFF0A2144);
    return ThemeHelper.surfaceVariant;
  }

  static Color get headerText => light ? Colors.white : ThemeHelper.textPrimary;
  static Color get success => light ? green : const Color(0xFF6EE7B7);
  static Color get successBg => light ? mint : const Color(0xFF0C3A2E).withValues(alpha: 0.55);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF08386A), Color(0xFF0E5E92), Color(0xFF12A3A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get headerGradient {
    if (ThemeHelper.isEyeComfort) {
      return const LinearGradient(
        colors: [Color(0xFF3A2E1C), Color(0xFF241C12)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (!light) {
      return const LinearGradient(
        colors: [Color(0xFF0B2A6F), Color(0xFF071833)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return brandGradient;
  }

  static List<BoxShadow> get cardShadow => light
      ? [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ]
      : const [];

  static BoxDecoration cardBox({Color? color, double radius = 22, Color? border}) {
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(radius),
      border: border == null ? null : Border.all(color: border),
      boxShadow: cardShadow,
    );
  }

  static Widget button({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool busy = false,
  }) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: Responsive.buttonHeight(context),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: action,
              foregroundColor: onAction,
              disabledBackgroundColor: action.withValues(alpha: 0.45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: TypeScale.body(size: 16, weight: FontWeight.w700, color: onAction),
            ),
            onPressed: busy ? null : onPressed,
            child: busy
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: onAction),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class RebsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RebsAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: RebsLook.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: RebsLook.inkColor),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TypeScale.body(size: 18, weight: FontWeight.w700, color: RebsLook.inkColor),
      ),
      actions: actions,
    );
  }
}

class RebsDock extends StatelessWidget {
  const RebsDock({super.key});

  static const _items = [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.event_available_outlined, activeIcon: Icons.event_available_rounded, label: 'Leave'),
    NavItem(icon: Icons.schedule_outlined, activeIcon: Icons.schedule_rounded, label: 'History'),
    NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final route = Get.currentRoute;
    final index = route == Routes.leave
        ? 1
        : route == Routes.history
            ? 2
            : 0;

    return Builder(
      builder: (ctx) => FloatingBottomNavBar(
        items: _items,
        currentIndex: index,
        accentColor: ThemeHelper.primaryColor,
        onItemSelected: (i) {
          if (i == 3) {
            Scaffold.of(ctx).openDrawer();
            return;
          }
          const dest = [Routes.dashboard, Routes.leave, Routes.history];
          _go(dest[i]);
        },
      ),
    );
  }

  void _go(String dest) {
    final current = Get.currentRoute;
    final onHome = current == Routes.dashboard || current == '/';
    if (dest == Routes.dashboard) {
      if (!onHome) Get.offAllNamed(Routes.dashboard);
      return;
    }
    if (current == dest) return;
    if (onHome) {
      Get.toNamed(dest);
    } else {
      Get.offNamed(dest);
    }
  }
}
