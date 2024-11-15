import 'package:flutter/material.dart';
import 'package:hydroponics_app/core/theme/app_palette.dart';

class AppTheme {
  static _border({Color color = AppPaletteDark.border, double width = 1.0}) =>
      OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: width,
            color: color,
          ));

  static ThemeData lightThemeMode() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: "Geist",
      scaffoldBackgroundColor: AppPaletteLight.background,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppPaletteLight.primary,
        onPrimary: AppPaletteLight.primaryForeground,
        secondary: AppPaletteLight.secondary,
        onSecondary: AppPaletteLight.secondaryForeground,
        tertiary: AppPaletteLight.tertiary,
        onTertiary: AppPaletteLight.tertiaryForeground,
        error: AppPaletteLight.error,
        onError: AppPaletteLight.errorForeground,
        surface: AppPaletteLight.background,
        onSurface: AppPaletteLight.foreground,
        surfaceDim: AppPaletteLight.mutedForeground,
        outline: AppPaletteLight.border,
      ),
    ).copyWith(
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      hintColor: AppPaletteLight.mutedForeground,
      // inputDecorationTheme: InputDecorationTheme(
      //   enabledBorder: _border(color: AppPaletteLight.border),
      //   disabledBorder:
      //       _border(color: AppPaletteLight.border.withOpacity(0.5), width: 1.0),
      //   focusedBorder: _border(width: 2.0, color: Colors.lightBlue.shade500),
      //   errorBorder:
      //       _border(color: AppPaletteLight.error.withOpacity(0.75), width: 1.0),
      //   focusedErrorBorder: _border(color: AppPaletteLight.error, width: 2.0),
      //   contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //   hintStyle: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.normal,
      //     letterSpacing: -0.4,
      //   ),
      // ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppPaletteLight.accentForeground,
        size: 24,
      ),
    );
  }

  static ThemeData darkThemeMode() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: "Geist",
      scaffoldBackgroundColor: AppPaletteDark.background,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.light,
        primary: AppPaletteDark.primary,
        onPrimary: AppPaletteDark.primaryForeground,
        secondary: AppPaletteDark.secondary,
        onSecondary: AppPaletteDark.secondaryForeground,
        tertiary: AppPaletteDark.tertiary,
        onTertiary: AppPaletteDark.tertiaryForeground,
        error: AppPaletteDark.error,
        onError: AppPaletteDark.errorForeground,
        surface: AppPaletteDark.background,
        onSurface: AppPaletteDark.foreground,
        surfaceDim: AppPaletteDark.mutedForeground,
        outline: AppPaletteDark.border,
      ),
    ).copyWith(
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      hintColor: AppPaletteDark.mutedForeground,
      // inputDecorationTheme: InputDecorationTheme(
      //   enabledBorder: _border(color: AppPaletteDark.border),
      //   disabledBorder:
      //       _border(color: AppPaletteDark.border.withOpacity(0.5), width: 1.0),
      //   focusedBorder: _border(width: 2.0, color: Colors.lightBlue.shade500),
      //   errorBorder:
      //       _border(color: AppPaletteDark.error.withOpacity(0.75), width: 1.0),
      //   focusedErrorBorder: _border(color: AppPaletteDark.error, width: 2.0),
      //   contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //   hintStyle: const TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.normal,
      //     letterSpacing: -0.4,
      //   ),
      // ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppPaletteDark.accentForeground,
        size: 24,
      ),
    );
  }
}
