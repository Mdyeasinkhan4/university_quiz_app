import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLight = Color(0xFF1B6EF3);
  static const Color onPrimaryLight = Colors.white;
  static const Color primaryContainerLight = Color(0xFFD3E4FF);
  static const Color onPrimaryContainerLight = Color(0xFF001D36);

  static const Color secondaryLight = Color(0xFF535F70);
  static const Color onSecondaryLight = Colors.white;
  static const Color secondaryContainerLight = Color(0xFFD7E3F7);
  static const Color onSecondaryContainerLight = Color(0xFF101C2B);

  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1C1E);

  static const Color primaryDark = Color(0xFF9ECEFF);
  static const Color onPrimaryDark = Color(0xFF00325B);
  static const Color primaryContainerDark = Color(0xFF00497D);
  static const Color onPrimaryContainerDark = Color(0xFFD3E4FF);

  static const Color secondaryDark = Color(0xFFBBC7DB);
  static const Color onSecondaryDark = Color(0xFF253140);
  static const Color secondaryContainerDark = Color(0xFF3B4858);
  static const Color onSecondaryContainerDark = Color(0xFFD7E3F7);

  static const Color backgroundDark = Color(0xFF121316);
  static const Color surfaceDark = Color(0xFF1A1C20);
  static const Color onSurfaceDark = Color(0xFFE2E2E6);

  // Quiz specific colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);
}

class QuizThemeExtension extends ThemeExtension<QuizThemeExtension> {
  final Color successColor;
  final Color warningColor;
  final Color cardBorderColor;
  final Color timerBackgroundColor;

  const QuizThemeExtension({
    required this.successColor,
    required this.warningColor,
    required this.cardBorderColor,
    required this.timerBackgroundColor,
  });

  @override
  QuizThemeExtension copyWith({
    Color? successColor,
    Color? warningColor,
    Color? cardBorderColor,
    Color? timerBackgroundColor,
  }) {
    return QuizThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      timerBackgroundColor: timerBackgroundColor ?? this.timerBackgroundColor,
    );
  }

  @override
  QuizThemeExtension lerp(ThemeExtension<QuizThemeExtension>? other, double t) {
    if (other is! QuizThemeExtension) return this;
    return QuizThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t)!,
      timerBackgroundColor: Color.lerp(timerBackgroundColor, other.timerBackgroundColor, t)!,
    );
  }

  static const light = QuizThemeExtension(
    successColor: Color(0xFF2E7D32),
    warningColor: Color(0xFFED6C02),
    cardBorderColor: Color(0xFFE0E0E0),
    timerBackgroundColor: Color(0xFFE3F2FD),
  );

  static const dark = QuizThemeExtension(
    successColor: Color(0xFF66BB6A),
    warningColor: Color(0xFFFFA726),
    cardBorderColor: Color(0xFF333538),
    timerBackgroundColor: Color(0xFF0D3349),
  );
}
