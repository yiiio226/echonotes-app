import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

/// AppSearch: 统一搜索输入框组件
/// - 使用设计系统的间距、圆角、颜色与输入装饰
/// - 封装常见属性：hint、controller、onChanged
/// - 不硬编码颜色，跟随主题 InputDecorationTheme
class AppSearch extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final EdgeInsetsGeometry? margin;

  const AppSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search…',
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color transparent = Colors.transparent;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: ADSTypography.body.copyWith(color: ADSColors.lightTextDisabled),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: ADSRadius.radiusLg,
            borderSide: const BorderSide(color: transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: ADSRadius.radiusLg,
            borderSide: const BorderSide(color: transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: ADSRadius.radiusLg,
            borderSide: const BorderSide(color: transparent, width: 1),
          ),
         
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.4),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: ADSSpacing.spaceLg,
            vertical: ADSSpacing.spaceSm,
          ),
        ),
      ),
    );
  }
}


