import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final displayLarge = GoogleFonts.cairo(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final headline = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final title = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final subtitle = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final body = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.8,
  );

  static final button = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final caption = GoogleFonts.cairo(
    fontSize: 13,
    color: Colors.grey,
  );
}