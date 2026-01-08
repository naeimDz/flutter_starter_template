import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/theme/app_text_styles.dart';

/// Application theme configuration.
///
/// Provides light and dark themes with consistent styling.
class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryLight,
          surface: AppColors.surfaceLight,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.textPrimaryLight,
          onError: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.textPrimaryLight,
          displayColor: AppColors.textPrimaryLight,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimaryLight,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: AppSizes.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusMd,
          ),
          color: AppColors.surfaceLight,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.borderRadiusSm,
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.borderRadiusSm,
            ),
            side: const BorderSide(color: AppColors.primary),
            textStyle: AppTextStyles.button,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.button,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.neutral[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiaryLight,
          ),
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.borderLight,
          thickness: AppSizes.dividerThickness,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.neutral[800],
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusSm,
          ),
          behavior: SnackBarBehavior.floating,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.neutral,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.neutral[400];
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryLight;
            }
            return AppColors.neutral[300];
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.white),
          side: BorderSide(color: AppColors.neutral[400]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          ),
        ),
      );

  /// Dark Theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondaryLight,
          secondaryContainer: AppColors.secondaryDark,
          surface: AppColors.surfaceDark,
          error: AppColors.errorLight,
          onPrimary: AppColors.black,
          onSecondary: AppColors.black,
          onSurface: AppColors.textPrimaryDark,
          onError: AppColors.black,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.textPrimaryDark,
          displayColor: AppColors.textPrimaryDark,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.textPrimaryDark,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: AppSizes.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusMd,
          ),
          color: AppColors.surfaceDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.black,
            minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.borderRadiusSm,
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.borderRadiusSm,
            ),
            side: const BorderSide(color: AppColors.primaryLight),
            textStyle: AppTextStyles.button,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: AppTextStyles.button,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.neutral[800],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.errorLight),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppSizes.borderRadiusSm,
            borderSide: const BorderSide(color: AppColors.errorLight, width: 2),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiaryDark,
          ),
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.borderDark,
          thickness: AppSizes.dividerThickness,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.neutral[200],
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.borderRadiusSm,
          ),
          behavior: SnackBarBehavior.floating,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.neutral,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.black,
          elevation: 4,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryLight,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryLight;
            }
            return AppColors.neutral[600];
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.neutral[700];
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.black),
          side: BorderSide(color: AppColors.neutral[600]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXs),
          ),
        ),
      );
}
