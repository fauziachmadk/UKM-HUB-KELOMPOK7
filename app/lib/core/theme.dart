// Modul: Token desain dan tema.
// Penanggung jawab: Fauzi Achmad Koesnaedi - 102022300352.
// Fondasi disediakan untuk integrasi; ownership bukan bukti kontribusi teman.
// BEGIN UKM07-FAUZI-THEME
// MULAI BAGIAN FAUZI.
// TODO(FAUZI): tinjau integrasi modul anggota, QA Android, dan bukti README final.
import 'package:flutter/material.dart';

abstract final class HubTheme {
  static ThemeData create(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF244B3D),
      brightness: brightness,
      primary: dark ? const Color(0xFFC4DFAC) : const Color(0xFF244B3D),
      onPrimary: dark ? const Color(0xFF1D3524) : const Color(0xFFF8F8EF),
      primaryContainer: dark
          ? const Color(0xFF354B2C)
          : const Color(0xFFD8EF90),
      onPrimaryContainer: dark
          ? const Color(0xFFD6ECBB)
          : const Color(0xFF2B4628),
      secondaryContainer: dark
          ? const Color(0xFF2A382E)
          : const Color(0xFFEEF0E6),
      surface: dark ? const Color(0xFF17221D) : const Color(0xFFF8F8F2),
      surfaceContainerLow: dark
          ? const Color(0xFF202E26)
          : const Color(0xFFFFFFFA),
      surfaceContainerHighest: dark
          ? const Color(0xFF2A382E)
          : const Color(0xFFEEF0E6),
      onSurface: dark ? const Color(0xFFEEF1E3) : const Color(0xFF202D27),
      onSurfaceVariant: dark
          ? const Color(0xFFB2BDAD)
          : const Color(0xFF657065),
      outlineVariant: dark ? const Color(0xFF3B4A3E) : const Color(0xFFDCE1D3),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
// END UKM07-FAUZI-THEME - FAUZI SAMPAI SINI.
