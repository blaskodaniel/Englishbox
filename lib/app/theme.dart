import 'package:flutter/material.dart';

/// Az Englishbox terv színei.
abstract final class AppColors {
  // Felületek
  static const background = Color(0xFF0E1016);
  static const surface = Color(0xFF181B24);
  static const surfaceAlt = Color(0xFF1C1F29);
  static const input = Color(0xFF14171F);
  static const navBar = Color(0xFF14171F);

  // Vonalak
  static const border = Color(0xFF262A36);
  static const borderStrong = Color(0xFF2C3140);
  static const navBorder = Color(0xFF232735);

  // Szöveg
  static const text = Color(0xFFF2F3F7);
  static const textMuted = Color(0xFFA3AABB);
  static const textSoft = Color(0xFFC9CEDA);

  // Lime akcentus: fő gombok, XP, aktív fül
  static const accent = Color(0xFFB8F35A);
  static const accentShadow = Color(0xFF6E9A2A);
  static const accentBg = Color(0xFF1A2410);
  static const onAccent = Color(0xFF10130A);

  // Streak
  static const streak = Color(0xFFFFB547);
  static const streakBg = Color(0xFF22180E);

  // Elemtípusok
  static const word = Color(0xFF5CC8FF);
  static const wordBg = Color(0xFF10233A);
  static const phrase = Color(0xFFB49CFF);
  static const phraseBg = Color(0xFF221A3A);
  static const rule = Color(0xFFFFB547);
  static const ruleBg = Color(0xFF2A1F10);
  static const sentence = Color(0xFF4FE0B0);
  static const sentenceBg = Color(0xFF0F2A24);

  // Elemtípusok halvány kerete (példakártyák, képletblokk-gomb)
  static const wordSoft = Color(0xFF1E4266);
  static const phraseSoft = Color(0xFF3A2F5C);
  static const ruleSoft = Color(0xFF5A4A2E);
  static const sentenceSoft = Color(0xFF1F5C4D);

  // Nyelvtani képlet: helykitöltő blokk háttere, kulcsszó szövege
  static const ruleSlot = Color(0xFF3A2C17);
  static const onRule = Color(0xFF2A1A05);

  // Hibás példa (✗ Wrong)
  static const wrong = Color(0xFFFF8A7A);
  static const wrongBg = Color(0xFF2E1714);
  static const wrongBorder = Color(0xFF6A2E27);
  static const wrongText = Color(0xFFE6CBC6);

  // Egyéb
  static const chipBg = Color(0xFF22262F);
  static const dashed = Color(0xFF3A3F4E);
}

/// Sarokkerekítések.
abstract final class AppRadii {
  static const chip = 12.0;
  static const button = 16.0;
  static const card = 20.0;
  static const panel = 24.0;
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    secondary: AppColors.word,
    surface: AppColors.background,
    onSurface: AppColors.text,
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surfaceAlt,
    outline: AppColors.borderStrong,
    outlineVariant: AppColors.border,
    error: Color(0xFFFF6B6B),
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    fontFamily: 'Lexend',
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: base.textTheme
        .copyWith(
          headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          bodyLarge: const TextStyle(fontSize: 16),
          bodyMedium: const TextStyle(fontSize: 15),
          bodySmall: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        )
        // A copyWith-ben megadott új TextStyle-okban nincs fontFamily,
        // ezért itt újra ráállítjuk a Lexendet az összes stílusra.
        .apply(
          fontFamily: 'Lexend',
          bodyColor: AppColors.text,
          displayColor: AppColors.text,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Lexend',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.input,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.button),
        borderSide: const BorderSide(color: AppColors.borderStrong, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.button),
        borderSide: const BorderSide(color: AppColors.word, width: 2),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.panel),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surfaceAlt,
      contentTextStyle: TextStyle(
        fontFamily: 'Lexend',
        fontSize: 15,
        color: AppColors.text,
      ),
    ),
  );
}
