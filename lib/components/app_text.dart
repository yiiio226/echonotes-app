// AppText: 语义化文本组件集合
//
// 目标：
// - 提供 Headline / Subtitle / Body / Caption 文本组件
// - 样式源自 AppDesignSystem，自动适配深浅色
// - 可通过 color 覆盖颜色，通过 softWrap/maxLines 控制换行

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';

class AppTextHeadline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const AppTextHeadline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ADSColors.darkTextPrimary
        : ADSColors.lightTextPrimary;

    return Text(
      text,
      style: ADSTypography.h1.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

class AppTextSubtitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const AppTextSubtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ADSColors.darkTextPrimary
        : ADSColors.lightTextPrimary;
    return Text(
      text,
      style: ADSTypography.h2.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

class AppTextTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const AppTextTitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ADSColors.darkTextPrimary
        : ADSColors.lightTextPrimary;
    return Text(
      text,
      style: ADSTypography.h3.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

class AppTextBody extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const AppTextBody(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ADSColors.darkTextSecondary
        : ADSColors.lightTextSecondary;
    return Text(
      text,
      style: ADSTypography.body.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}

class AppTextCaption extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const AppTextCaption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ADSColors.darkTextSecondary
        : ADSColors.lightTextSecondary;
    return Text(
      text,
      style: ADSTypography.caption.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}


