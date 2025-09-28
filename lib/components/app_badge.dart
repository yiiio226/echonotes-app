// AppBadge: 徽章/标签组件（用于“Best Value”“Save 35%”等）
//
// 设计约束：
// - 仅消费设计系统令牌（颜色/圆角/排版/间距）
// - 支持主要/次要两种语义（primary / neutral）
// - 可选图标，自动适配深浅色

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

enum AppBadgeVariant { primary, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bool isPrimary = variant == AppBadgeVariant.primary;

    final Color bg = isPrimary
        ? ADSColors.lightButtonPrimary
        : (theme.brightness == Brightness.dark
            ? ADSColors.darkDivider
            : ADSColors.lightDivider);
    final Color fg = isPrimary
        ? cs.onPrimary
        : (theme.brightness == Brightness.dark
            ? ADSColors.darkTextPrimary
            : ADSColors.lightTextPrimary);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: ADSRadius.radiusMd,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ADSSpacing.spaceLg,
        vertical: ADSSpacing.spaceXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: ADSSpacing.spaceSm),
          ],
          Text(
            label,
            style: ADSTypography.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


