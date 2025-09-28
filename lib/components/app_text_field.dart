import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

/// AppTextField: 基础输入框
/// - 统一圆角、间距、字重与边框/聚焦样式
/// - 支持居中/对齐、占位、初始值
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextAlign textAlign;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.textAlign = TextAlign.center,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color borderColor = theme.brightness == Brightness.dark
        ? ADSColors.darkDivider
        : ADSColors.lightDivider;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      textAlign: textAlign,
      style: ADSTypography.h2.copyWith(
        color: theme.textTheme.titleMedium?.color,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            ADSTypography.body.copyWith(color: ADSColors.lightTextDisabled),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ADSSpacing.spaceXl,
          vertical: ADSSpacing.spaceSm,
        ),
        border: OutlineInputBorder(
          borderRadius: ADSRadius.radiusLg,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ADSRadius.radiusLg,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ADSRadius.radiusLg,
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
    );
  }
}


