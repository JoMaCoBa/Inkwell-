import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InkwellColors {
  static const background   = Color(0xFFFFFDF7);
  static const surface      = Color(0xFFFFFFFF);
  static const border       = Color(0xFF111111);
  static const shadow       = Color(0xFF111111);
  static const yellow       = Color(0xFFFFE500);
  static const yellowDark   = Color(0xFFCCB800);
  static const coverRed     = Color(0xFFFF6B6B);
  static const coverTeal    = Color(0xFF4ECDC4);
  static const coverPurple  = Color(0xFFA78BFA);
  static const coverOrange  = Color(0xFFFF9F43);
  static const coverBlue    = Color(0xFF48CAE4);
  static const coverGreen   = Color(0xFF6BCB77);
  static const badgeNew     = Color(0xFFFF6B6B);
  static const badgeInfo    = Color(0xFF4ECDC4);
  static const badgePrimary = Color(0xFFFFE500);
  static const textPrimary  = Color(0xFF111111);
  static const textSecondary= Color(0xFF555555);
  static const textMuted    = Color(0xFF888888);
  static const textOnYellow = Color(0xFF111111);
  static const textOnDark   = Color(0xFFFFFFFF);
  static const progressBg   = Color(0xFFE0E0E0);
  static const progressFill = yellow;

  static const coverPalette = [
    coverRed, coverTeal, coverPurple, coverOrange, coverBlue, coverGreen,
  ];

  static Color coverColorFor(int index) =>
      coverPalette[index % coverPalette.length];
}

class InkwellShadows {
  static const card   = BoxShadow(color: Color(0xFF111111), offset: Offset(4, 4));
  static const button = BoxShadow(color: Color(0xFF111111), offset: Offset(3, 3));
  static const small  = BoxShadow(color: Color(0xFF111111), offset: Offset(2, 2));
}

class InkwellTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: InkwellColors.background,
        colorScheme: const ColorScheme.light(
          primary: InkwellColors.yellow,
          onPrimary: InkwellColors.textPrimary,
          surface: InkwellColors.surface,
          onSurface: InkwellColors.textPrimary,
        ),
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: InkwellColors.yellow,
          foregroundColor: InkwellColors.textPrimary,
          elevation: 0,
          titleTextStyle: GoogleFonts.bangers(
            fontSize: 28,
            letterSpacing: 2,
            color: InkwellColors.textPrimary,
          ),
          shape: const Border(
            bottom: BorderSide(color: InkwellColors.border, width: 3),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: InkwellColors.background,
          selectedItemColor: InkwellColors.textPrimary,
          unselectedItemColor: InkwellColors.textMuted,
          elevation: 0,
        ),
        useMaterial3: false,
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.bangers(
            fontSize: 48, letterSpacing: 3, color: InkwellColors.textPrimary),
        displayMedium: GoogleFonts.bangers(
            fontSize: 36, letterSpacing: 2.5, color: InkwellColors.textPrimary),
        titleLarge: GoogleFonts.bangers(
            fontSize: 28, letterSpacing: 2, color: InkwellColors.textPrimary),
        titleMedium: GoogleFonts.bangers(
            fontSize: 22, letterSpacing: 1.5, color: InkwellColors.textPrimary),
        labelLarge: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: InkwellColors.textPrimary,
            letterSpacing: 1.5),
        bodyLarge: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: InkwellColors.textPrimary),
        bodyMedium: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: InkwellColors.textSecondary),
        bodySmall: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: InkwellColors.textMuted),
      );
}
