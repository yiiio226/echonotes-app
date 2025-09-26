// AppCard: 基础卡片容器
//
// 目标：
// - 复用 AppDesignSystem.appCardTheme 提供的基础卡片风格
// - 控制背景、圆角、阴影、内边距
// - 适合作为可复用的内容容器

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final AppCardTheme base = ADSAppCardTheme.appCardTheme(brightness);

    final Widget content = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? base.backgroundColor,
        borderRadius: borderRadius ?? base.borderRadius,
        boxShadow: base.shadows,
      ),
      padding: padding ?? base.padding,
      child: child,
    );

    if (onTap != null) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius ?? base.borderRadius,
          onTap: onTap,
          child: content,
        ),
      );
    }
    return content;
  }
}


