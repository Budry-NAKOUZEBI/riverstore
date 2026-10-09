import 'package:flutter/material.dart';

/// Identité visuelle « fleuve et latérite » :
/// - vert profond du fleuve Congo (couleur principale) ;
/// - terracotta de la latérite (actions d'achat, accents) ;
/// - or (mises en avant, motif wax) ;
/// - fond crème chaud plutôt qu'un blanc clinique.
abstract final class AppTheme {
  static const displayFont = 'BricolageGrotesque';
  static const bodyFont = 'PlusJakartaSans';

  /// Couleurs de marque utilisées par le motif wax (indépendantes du thème).
  static const river = Color(0xFF0B4F44);
  static const riverDeep = Color(0xFF06332C);
  static const laterite = Color(0xFFB4461E);
  static const gold = Color(0xFFE3A72F);

  static const _light = ColorScheme(
    brightness: Brightness.light,
    primary: river,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCFE8DF),
    onPrimaryContainer: Color(0xFF00201A),
    secondary: laterite,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFDBCC),
    onSecondaryContainer: Color(0xFF3A0B00),
    tertiary: Color(0xFF7A5600),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE3A6),
    onTertiaryContainer: Color(0xFF261900),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFBF7F0),
    onSurface: Color(0xFF1C1B17),
    onSurfaceVariant: Color(0xFF4E4A42),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF6F1E8),
    surfaceContainer: Color(0xFFF1EBE0),
    surfaceContainerHigh: Color(0xFFEBE4D8),
    surfaceContainerHighest: Color(0xFFE4DDD0),
    outline: Color(0xFF7D776C),
    outlineVariant: Color(0xFFD9D2C4),
    inverseSurface: Color(0xFF31302B),
    onInverseSurface: Color(0xFFF4F0E8),
    inversePrimary: Color(0xFF7FD3BF),
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static const _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7FD3BF),
    onPrimary: Color(0xFF00382F),
    primaryContainer: river,
    onPrimaryContainer: Color(0xFFCFE8DF),
    secondary: Color(0xFFFFB59A),
    onSecondary: Color(0xFF5C1900),
    secondaryContainer: Color(0xFF8A3412),
    onSecondaryContainer: Color(0xFFFFDBCC),
    tertiary: Color(0xFFF2C46A),
    onTertiary: Color(0xFF412D00),
    tertiaryContainer: Color(0xFF5D4200),
    onTertiaryContainer: Color(0xFFFFE3A6),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121412),
    onSurface: Color(0xFFE6E2DA),
    onSurfaceVariant: Color(0xFFC9C3B7),
    surfaceContainerLowest: Color(0xFF0D0F0D),
    surfaceContainerLow: Color(0xFF1A1C19),
    surfaceContainer: Color(0xFF1E201D),
    surfaceContainerHigh: Color(0xFF282A27),
    surfaceContainerHighest: Color(0xFF333532),
    outline: Color(0xFF938E83),
    outlineVariant: Color(0xFF48463F),
    inverseSurface: Color(0xFFE6E2DA),
    onInverseSurface: Color(0xFF31302B),
    inversePrimary: river,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static ThemeData get light => _build(_light);

  static ThemeData get dark => _build(_dark);

  static ThemeData _build(ColorScheme colors) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: bodyFont,
    );
    final text = base.textTheme;
    TextStyle? display(TextStyle? style, FontWeight weight) => style?.copyWith(
      fontFamily: displayFont,
      fontWeight: weight,
      letterSpacing: -0.4,
    );
    final textTheme = text.copyWith(
      displayLarge: display(text.displayLarge, FontWeight.w800),
      displayMedium: display(text.displayMedium, FontWeight.w800),
      displaySmall: display(text.displaySmall, FontWeight.w800),
      headlineLarge: display(text.headlineLarge, FontWeight.w800),
      headlineMedium: display(text.headlineMedium, FontWeight.w800),
      headlineSmall: display(text.headlineSmall, FontWeight.w700),
      titleLarge: display(text.titleLarge, FontWeight.w700),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );
    final rounded16 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.5,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colors.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 54),
          shape: rounded16,
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: rounded16,
          side: BorderSide(color: colors.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        border: inputBorder(colors.outlineVariant),
        enabledBorder: inputBorder(colors.outlineVariant),
        focusedBorder: inputBorder(colors.primary, 2),
        errorBorder: inputBorder(colors.error),
        focusedErrorBorder: inputBorder(colors.error, 2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: colors.outlineVariant),
        backgroundColor: colors.surfaceContainerLowest,
        selectedColor: colors.primary,
        labelStyle: textTheme.labelLarge?.copyWith(color: colors.onSurface),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceContainerLowest,
        indicatorColor: colors.tertiaryContainer,
        surfaceTintColor: Colors.transparent,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? colors.onSurface
                : colors.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surfaceContainerLowest,
        indicatorColor: colors.tertiaryContainer,
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: colors.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: rounded16,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onInverseSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant, space: 1),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleSmall?.copyWith(color: colors.onSurface),
      ),
    );
  }
}
