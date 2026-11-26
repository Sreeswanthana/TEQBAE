import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/rebs_look.dart';
import '../theme/theme_helper.dart';

/// Wraps skeleton placeholders with theme-aware shimmer animation.
class RebsShimmer extends StatelessWidget {
  const RebsShimmer({super.key, required this.child});

  final Widget child;

  static Color get _base {
    if (ThemeHelper.isLight) return const Color(0xFFDCE4EE);
    if (ThemeHelper.isDark) return const Color(0xFF152238);
    return const Color(0xFF2A241C);
  }

  static Color get _highlight {
    if (ThemeHelper.isLight) return const Color(0xFFF4F8FC);
    if (ThemeHelper.isDark) return const Color(0xFF243552);
    return const Color(0xFF3A3228);
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, this.radius = 12});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: RebsLook.card,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return RebsShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const _Bone(width: 44, height: 44, radius: 14),
                const SizedBox(width: 12),
                const _Bone(width: 48, height: 48, radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bone(width: 72, height: 10, radius: 6),
                      SizedBox(height: 8),
                      _Bone(width: double.infinity, height: 16, radius: 8),
                      SizedBox(height: 6),
                      _Bone(width: 180, height: 12, radius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const _Bone(width: 44, height: 44, radius: 14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: const [
                _Bone(width: double.infinity, height: 220, radius: 22),
                SizedBox(height: 12),
                _Bone(width: double.infinity, height: 140, radius: 22),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _Bone(height: 120, radius: 18)),
                    SizedBox(width: 12),
                    Expanded(child: _Bone(height: 120, radius: 18)),
                  ],
                ),
                SizedBox(height: 16),
                _Bone(width: 140, height: 12, radius: 6),
                SizedBox(height: 10),
                _Bone(width: double.infinity, height: 180, radius: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPageShimmer extends StatelessWidget {
  const HistoryPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return RebsShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => const _Bone(width: double.infinity, height: 88, radius: 18),
      ),
    );
  }
}

class LeaveApplyShimmer extends StatelessWidget {
  const LeaveApplyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return RebsShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
        children: const [
          _Bone(width: double.infinity, height: 100, radius: 18),
          SizedBox(height: 16),
          _Bone(width: 120, height: 14, radius: 6),
          SizedBox(height: 10),
          _Bone(width: double.infinity, height: 52, radius: 14),
          SizedBox(height: 14),
          _Bone(width: 100, height: 14, radius: 6),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _Bone(height: 44, radius: 12)),
              SizedBox(width: 8),
              Expanded(child: _Bone(height: 44, radius: 12)),
            ],
          ),
          SizedBox(height: 16),
          _Bone(width: double.infinity, height: 120, radius: 14),
          SizedBox(height: 20),
          _Bone(width: double.infinity, height: 52, radius: 14),
        ],
      ),
    );
  }
}

class LeaveHistoryShimmer extends StatelessWidget {
  const LeaveHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return RebsShimmer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                _Bone(width: 64, height: 32, radius: 16),
                SizedBox(width: 8),
                _Bone(width: 80, height: 32, radius: 16),
                SizedBox(width: 8),
                _Bone(width: 72, height: 32, radius: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, __) => const _Bone(width: double.infinity, height: 96, radius: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendancePageShimmer extends StatelessWidget {
  const AttendancePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return RebsShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: const [
          _Bone(width: double.infinity, height: 160, radius: 22),
          SizedBox(height: 16),
          _Bone(width: double.infinity, height: 72, radius: 16),
          SizedBox(height: 14),
          _Bone(width: double.infinity, height: 200, radius: 18),
          SizedBox(height: 18),
          _Bone(width: double.infinity, height: 52, radius: 14),
        ],
      ),
    );
  }
}