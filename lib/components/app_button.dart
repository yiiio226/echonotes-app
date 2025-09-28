// AppButton: 统一按钮组件
//
// 目标：
// - 仅消费 AppDesignSystem 令牌，不硬编码样式
// - 提供最常用的主按钮（primary）与次按钮（secondary）
// - 易于扩展：可新增大小、加载态、图标等

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

/// 语义化按钮类型
enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expanded; // 是否占满横向空间

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // 主题可用于派生其他样式，如需要时再读取
    // final ThemeData theme = Theme.of(context);
    // final ColorScheme scheme = theme.colorScheme;

    // 根据 variant 选择语义色
    final Color backgroundColor = switch (variant) {
      AppButtonVariant.primary => ADSColors.buttonPrimary,
      AppButtonVariant.secondary => ADSColors.secondary,
    };

    final Color foregroundColor = Colors.white;

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: ADSTypography.body,
      padding: const EdgeInsets.symmetric(
        horizontal: ADSSpacing.spaceXl,
        vertical: ADSSpacing.spaceSm,
      ),
      //minimumSize: const Size(0, 48), // 设置最小高度确保垂直居中
      shape: RoundedRectangleBorder(borderRadius: ADSRadius.radiusMd),
      elevation: 0,
    );

    final Widget button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}


