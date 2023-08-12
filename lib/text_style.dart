import 'package:flutter/material.dart';
import 'package:sqlite_data/config/colors.dart';

class Style {
  TextStyle get dialog {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.bgColor,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get dialog1 {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.lightWhite2,
      fontWeight: FontWeight.w700,
    );
  }
}
