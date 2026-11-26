import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_helper.dart';

/// One tab in the floating nav.
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool showBadge;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.showBadge = false,
  });
}

/// Floating frosted-glass pill bottom bar.
/// Selected tab expands and shows its label.
class FloatingBottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  /// Accent used for the selected pill. Default is the HRMS blue.
  final Color accentColor;

  const FloatingBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.accentColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor;
    final bar = ThemeHelper.isLight
        ? Colors.white.withValues(alpha: 0.92)
        : (ThemeHelper.isDark ? const Color(0xFF0E2A52).withValues(alpha: 0.94) : ThemeHelper.navBarBg.withValues(alpha: 0.94));
    final edge = ThemeHelper.isLight ? const Color(0xFFE4EDF6) : (ThemeHelper.isDark ? const Color(0xFF1E4578) : ThemeHelper.cardBorder);
    final width = MediaQuery.sizeOf(context).width;
    final side = width < 360 ? 10.0 : (width >= 840 ? 32.0 : 18.0);
    final bottom = width < 360 ? 10.0 : 18.0;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: side, right: side, bottom: bottom),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: bar,
                border: Border.all(color: edge, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: List.generate(
                    items.length,
                    (index) => Expanded(
                      child: _NavBarItem(
                        item: items[index],
                        isSelected: index == currentIndex,
                        accentColor: accent,
                        onAccent: ThemeHelper.onPrimary,
                        idleColor: ThemeHelper.textSecondary,
                        onTap: () => onItemSelected(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final Color accentColor;
  final Color onAccent;
  final Color idleColor;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.accentColor,
    required this.onAccent,
    required this.idleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 380;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    accentColor,
                    Color.lerp(accentColor, Colors.white, 0.18)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? onAccent : idleColor,
              size: narrow ? 20 : 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: onAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: narrow ? 11 : 12,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
