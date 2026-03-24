import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  static TextStyle get appName => GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.textPrimary);
  static TextStyle get h1 => GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle get h2 => GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get h3 => GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get bodyLarge => GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static TextStyle get body => GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w400, height: 1.57, color: AppColors.textPrimary);
  static TextStyle get caption => GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get badge => GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w700);
}
