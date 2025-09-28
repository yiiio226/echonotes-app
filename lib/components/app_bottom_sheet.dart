import 'package:flutter/material.dart';

/// AppBottomSheet: 统一的底部抽屉容器
/// - 使用 SafeArea、圆角与系统背景色
/// - 内置内容 padding 与可选标题/副标题
class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 24),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double kb = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: kb),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}


