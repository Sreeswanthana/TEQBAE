import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_helper.dart';

class TypeScale {
  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color? color,
    double tracking = -0.4,
    double height = 1.15,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: tracking,
      height: height,
      color: color ?? ThemeHelper.textPrimary,
    );
  }

  static TextStyle kicker({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: color ?? ThemeHelper.textSecondary,
    );
  }

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color? color,
    double height = 1.35,
    double tracking = 0,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: tracking,
      color: color ?? ThemeHelper.textPrimary,
    );
  }
}
