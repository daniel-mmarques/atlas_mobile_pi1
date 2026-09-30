import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_palette.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppThemes {
  static final Map<AppThemeId, ThemeData> _cache = {};

  static ThemeData of(AppThemeId id) =>
      _cache.putIfAbsent(id, () => _build(AppPalettes.of(id)));

  /// Compat: tema claro padrão.
  static ThemeData get lightTheme => of(AppThemeId.light);

  /// Compat: tema escuro AMOLED padrão.
  static ThemeData get darkTheme => of(AppThemeId.dark);

  static ThemeData? _authCache;

  /// Tema fixo preto / branco / prata do funil de autenticação.
  static ThemeData get auth => _authCache ??= _build(AppPalettes.auth);

  static ThemeData _build(AppPalette palette) {
    final colorScheme = ColorScheme(
      brightness: palette.brightness,
      primary: palette.accent,
      onPrimary: palette.onAccent,
      secondary: palette.component,
      onSecondary: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      onSurfaceVariant: palette.textSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      outline: palette.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      scaffoldBackgroundColor: palette.scaffold,
      colorScheme: colorScheme,
      cardColor: palette.surface,
      dividerColor: colorScheme.outline.withValues(alpha: 0.35),
      textTheme: AppTypography.textThemeForPalette(palette),
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.scaffold,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle:
            AppTypography.textThemeForPalette(palette).headlineSmall,
        systemOverlayStyle: palette.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.component,
          foregroundColor: palette.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.component,
          foregroundColor: palette.textPrimary,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.component,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardSm),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.component,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.button,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.button,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.button,
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        hintStyle: TextStyle(color: palette.textSecondary),
        labelStyle: TextStyle(color: palette.textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.component,
        selectedColor: palette.accent,
        labelStyle: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: TextStyle(color: palette.onAccent),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pill),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.scaffold,
        selectedItemColor: palette.textPrimary,
        unselectedItemColor: palette.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.scaffold,
        modalBackgroundColor: palette.scaffold,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        elevation: 0,
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.card),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.component,
        contentTextStyle: TextStyle(color: palette.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardSm),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textPrimary,
        textColor: palette.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      iconTheme: IconThemeData(color: palette.textPrimary, size: 24),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.accent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.onAccent;
          return palette.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.accent;
          return palette.component;
        }),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.35),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
