// EchoNotes Design System (AppDesignSystem)
//
// 该文件定义了应用的所有设计令牌与主题，包括：
// - 颜色（色板 / 语义色）
// - 字体排版（Typography）
// - 间距（Spacing）
// - 圆角（Border Radius）
// - 阴影与海拔（Shadows / Elevation）
// - 主题（ThemeData）
// - 基础卡片风格（AppCardTheme）
//
// 使用方式：所有 UI 组件仅从本文件读取设计令牌，不直接硬编码颜色/字体/间距。
// 好处：统一风格、便于深浅色主题切换、后续按需扩展集中维护。

import 'package:flutter/material.dart';

/// 应用统一设计系统的入口。
///
/// - 通过静态常量暴露设计令牌（颜色、字号、间距、圆角等）。
/// - 暴露 `lightTheme` 与 `darkTheme` 供 `MaterialApp` 使用。
/// - 提供 `AppCardTheme` 作为卡片基础样式，供 `AppCard` 复用。
class ADSBrand {
  static const String appName = 'EchoNotes';
}

  class ADSColors {

  // =============================
  // 颜色 Color Palette（语义化）
  // =============================
  // 命名以用途为导向，便于在组件中直接引用。
  static const Color primary = Color(0xFFB5D0CC); // 主品牌色（按钮、强调）
  static const Color secondary = Color(0xFFE8F7F5); // 次级品牌色（辅助强调）


  // Light 组件语义色（如需与品牌主色区分，可单独定义）
  static const Color lightButtonPrimary = Color(0xFF0F172A); // 主按钮背景（深黑）

  // Light 主题基础色
  static const Color lightBackground = Color(0xFFF8FAFC); // 页面背景
  static const Color lightSurface = Color(0xFFFFFFFF); // 卡片/容器背景
  static const Color lightDivider = Color(0xFFE2E8F0); // 分隔线/边框

  // Light 主题状态色
  static const Color lightError = Color(0xFFEF4444); // 错误色
  static const Color lightSuccess = Color(0xFF10B981); // 成功色
  static const Color lightWarning = Color(0xFFF59E0B); // 警告色

  // Light 主题文字色
  static const Color lightTextPrimary = Color(0xFF0F172A); // 主要文本
  static const Color lightTextSecondary = Color(0xFF475569); // 次要文本
  static const Color lightTextDisabled = Color(0xFF9CA3AF); // 占位/禁用


  // Light 组件语义色（如需与品牌主色区分，可单独定义）
  static const Color darkButtonPrimary = Color(0xFFFFFFFF); // 主按钮背景（深黑）

  // Dark 主题基础色
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827); //
  static const Color darkDivider = Color(0xFF273042); // 分隔线/边框

  // Dark 主题状态色
  static const Color darkError = Color(0xFFF87171);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkWarning = Color(0xFFF59E0B);

  // Dark 主题文本色
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextDisabled = Color(0xFF9CA3AF); // 占位/禁用

  // 半透明用于蒙层/涟漪
  static const Color lightShadow = Color(0x14000000);
  static const Color darkShadow = Color(0x66000000);
}


  // =============================
  // 字体排版 Typography
  // =============================
  // 将字号/字重组合成语义等级，避免在组件中散落定义。
class ADSTypography {
  // 全局字体家族（如需指定 Inter/SF Pro，可在此统一替换）
  static const String? _fontFamily = null;

  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: ADSColors.lightTextPrimary,
    fontFamily: _fontFamily,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: ADSColors.lightTextPrimary,
    fontFamily: _fontFamily,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: ADSColors.lightTextPrimary,
    fontFamily: _fontFamily,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: ADSColors.lightTextSecondary,
    fontFamily: _fontFamily,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: ADSColors.lightTextSecondary,
    fontFamily: _fontFamily,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: _fontFamily,
  );
}

class ADSSpacing {


  // =============================
  // 间距 Spacing（8pt 基线）
  // =============================
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
}

class ADSRadius {
  // =============================
  // 圆角 Border Radius
  // =============================
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(6));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16));
}



class ADSShadow {
  // =============================
  // 阴影与海拔 Shadows / Elevations
  // =============================
  // 使用统一的阴影集合，浅色与深色会在主题中做差异化细调。
  static const List<BoxShadow> cardShadowsLight = [
    BoxShadow(
      color: ADSColors.lightShadow, // 12% 黑色投影
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> cardShadowsDark = [
    BoxShadow(
      color: ADSColors.darkShadow, // 40% 黑色投影，暗色增强层次
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}

class ADSAppCardTheme {
  // =============================
  // 基础卡片主题 AppCardTheme
  // =============================
  // 定义卡片的通用外观：圆角、背景色、阴影与内容内边距。
  // 注意：组件层通过该结构承载配置，避免在组件内部写死样式。
  static AppCardTheme appCardTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return AppCardTheme(
      backgroundColor: isDark ? ADSColors.darkSurface : ADSColors.lightSurface,
      padding: const EdgeInsets.all(ADSSpacing.spaceLg),
      borderRadius: ADSRadius.radiusLg,
      shadows: isDark ? ADSShadow.cardShadowsDark : ADSShadow.cardShadowsLight,
    );
  }
}

class ADSTheme {
  // =============================
  // 主题 ThemeData（Light / Dark）
  // =============================
  // 这些主题会被应用到 MaterialApp。组件通过 Theme.of(context) 访问。
  static ThemeData get lightTheme {
    final ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: ADSColors.primary,
      onPrimary: Colors.white,
      secondary: ADSColors.secondary,
      onSecondary: Colors.white,
      error: ADSColors.lightError,
      onError: Colors.white,
   
      surface: ADSColors.lightSurface,
      onSurface: ADSColors.lightTextPrimary,
    );

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ADSColors.lightBackground,
      textTheme: TextTheme(
        headlineSmall: ADSTypography.h1.copyWith(color: ADSColors.lightTextPrimary),
        titleMedium: ADSTypography.h2.copyWith(color: ADSColors.lightTextPrimary),
        bodyMedium: ADSTypography.body.copyWith(color: ADSColors.lightTextSecondary),
        bodySmall: ADSTypography.caption.copyWith(color: ADSColors.lightTextSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ADSColors.lightSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: ADSColors.lightTextPrimary),
        titleTextStyle: ADSTypography.h2.copyWith(color: ADSColors.lightTextPrimary),
      ),
      cardTheme: CardTheme(
        color: ADSColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: ADSRadius.radiusLg),
        margin: const EdgeInsets.all(ADSSpacing.spaceLg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: ADSSpacing.spaceXl,
            vertical: ADSSpacing.spaceSm,
          ),
          shape: RoundedRectangleBorder(borderRadius: ADSRadius.radiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: ADSRadius.radiusMd),
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ADSColors.primary,
      onPrimary: Colors.white,
      secondary: ADSColors.secondary,
      onSecondary: Colors.white,
      error: ADSColors.darkError,
      onError: Colors.white,
      surface: ADSColors.darkBackground,
      onSurface: ADSColors.darkTextPrimary,
 
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ADSColors.darkBackground,
      textTheme: TextTheme(
        headlineSmall: ADSTypography.h1.copyWith(color: ADSColors.darkTextPrimary),
        titleMedium: ADSTypography.h2.copyWith(color: ADSColors.darkTextPrimary),
        bodyMedium: ADSTypography.body.copyWith(color: ADSColors.darkTextSecondary),
        bodySmall: ADSTypography.caption.copyWith(color: ADSColors.darkTextSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ADSColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: ADSColors.darkTextPrimary),
        titleTextStyle: ADSTypography.h2.copyWith(color: ADSColors.darkTextPrimary),
      ),
      cardTheme: CardTheme(
        color: ADSColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: ADSRadius.radiusLg),
        margin: const EdgeInsets.all(ADSSpacing.spaceLg),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: ADSSpacing.spaceXl,
            vertical: ADSSpacing.spaceSm,
          ),
          shape: RoundedRectangleBorder(borderRadius: ADSRadius.radiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: ADSRadius.radiusMd),
      ),
    );
  }
}


/// 基础卡片主题对象。
///
/// 该结构与 `ThemeData.cardTheme` 互补：
/// - `CardTheme` 控制 Material Card 的默认外观。
/// - `AppCardTheme` 供我们自定义的 `AppCard` 组件使用，控制 padding、阴影等。
class AppCardTheme {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  const AppCardTheme({
    required this.backgroundColor,
    required this.padding,
    required this.borderRadius,
    required this.shadows,
  });
}
