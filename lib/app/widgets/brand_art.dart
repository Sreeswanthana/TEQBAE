import 'package:flutter/material.dart';

/// Illustrated assets supplied for the REBS screens.
class BrandArt {
  static const pin = 'assets/brand/pin.png';
  static const office = 'assets/brand/office.png';
  static const map = 'assets/brand/map.png';
  static const calendarCheck = 'assets/brand/calendar_check.png';
  static const clock = 'assets/brand/clock.png';
  static const check = 'assets/brand/check_circle.png';
  static const airplane = 'assets/brand/airplane.png';
  static const document = 'assets/brand/document_clock.png';
  static const briefcase = 'assets/brand/briefcase.png';
  static const trophy = 'assets/brand/trophy.png';
  static const user = 'assets/brand/user.png';
  static const gear = 'assets/brand/gear.png';
  static const offline = 'assets/brand/no_internet.png';
  static const sync = 'assets/brand/sync.png';
  static const beach = 'assets/brand/beach.png';
  static const calendarClock = 'assets/brand/calendar_clock.png';
  static const clipboard = 'assets/brand/clipboard.png';
  static const woman = 'assets/brand/woman_laptop.png';
  static const thumbs = 'assets/brand/man_thumbs.png';
}

class BrandIcon extends StatelessWidget {
  final String asset;
  final double size;

  const BrandIcon(this.asset, {super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
