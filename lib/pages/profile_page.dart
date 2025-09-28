import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_button.dart';
import 'package:echonotes/components/app_bottom_sheet.dart';
import 'package:echonotes/components/app_text_field.dart';
import 'package:echonotes/pages/upgrade_page.dart';
import 'package:echonotes/pages/privacy_settings_page.dart';
import 'package:echonotes/pages/help_feedback_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ProfilePage（TSX + 设计图 -> Flutter 静态映射）
///
/// - Header: 返回箭头 + 标题 -> AppBar（仅图标交互留 TODO）
/// - User Info: 头像占位 + 名称/邮箱项 -> AppCard 列表行
/// - Subscription: 订阅信息 + 升级按钮 -> AppCard + AppButton + 次级卡片块
/// - Settings: 设置项列表（云同步开关、隐私、帮助）-> AppCard 行 + 图标容器
/// - More: 更多操作（删除账号、退出登录）-> AppCard 行（错误/警告语义色）
/// - Footer: 版本信息 -> 文本
///
/// 样式仅使用设计系统令牌（颜色、间距、圆角、排版），交互均以 TODO 标注。
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _displayName = 'John Doe';
  late final TextEditingController _nameCtrl =
      TextEditingController(text: _displayName);
  String? _avatarPath; // 本地头像路径
  
  // SharedPreferences 键名
  static const String _displayNameKey = 'user_display_name';
  static const String _avatarPathKey = 'user_avatar_path';

  Color _successColor(Brightness b) =>
      b == Brightness.dark ? ADSColors.darkSuccess : ADSColors.lightSuccess;

  Color _warningColor(Brightness b) =>
      b == Brightness.dark ? ADSColors.darkWarning : ADSColors.lightWarning;

  Color _errorColor(Brightness b) =>
      b == Brightness.dark ? ADSColors.darkError : ADSColors.lightError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 加载用户数据
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString(_displayNameKey) ?? 'John Doe';
      _avatarPath = prefs.getString(_avatarPathKey);
      _nameCtrl.text = _displayName;
    });
  }

  // 保存显示名称
  Future<void> _saveDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_displayNameKey, name);
  }

  // 保存头像路径
  Future<void> _saveAvatarPath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_avatarPathKey, path);
    } else {
      await prefs.remove(_avatarPathKey);
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _avatarPath = image.path;
        });
        await _saveAvatarPath(image.path);
      }
    } catch (_) {
      // TODO: 处理授权失败/用户取消
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brightness = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppTextSubtitle('Profile'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          ADSSpacing.spaceXl,
          ADSSpacing.spaceLg,
          ADSSpacing.spaceXl,
          ADSSpacing.spaceXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ 用户头像 ============
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _avatarPath == null
                          ? Container(
                              color: cs.primary,
                              child: Icon(
                                Icons.person_outline,
                                size: 36,
                                color: ADSColors.lightSurface,
                              ),
                            )
                          : Image.file(
                              File(_avatarPath!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: ADSSpacing.spaceXl),
                ],
              ),
            ),

            // ============ 可编辑名称项 ============
            AppCard(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => AppBottomSheet(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: ADSSpacing.spaceSm),
                        const AppTextSubtitle('Edit Name'),
                        const SizedBox(height: ADSSpacing.spaceSm),
                        AppTextBody('Enter your new display name'),
                        const SizedBox(height: ADSSpacing.spaceXl),
                        AppTextField(
                          controller: _nameCtrl,
                          hintText: 'Your name',
                          autofocus: true,
                        ),
                        const SizedBox(height: ADSSpacing.spaceXl),
                        AppButton(
                          label: 'Save Changes',
                          onPressed: () async {
                            final String next = _nameCtrl.text.trim();
                            if (next.isNotEmpty) {
                              setState(() {
                                _displayName = next;
                              });
                              await _saveDisplayName(next);
                            }
                            Navigator.of(context).maybePop();
                          },
                          expanded: true,
                        ),
                        const SizedBox(height: ADSSpacing.spaceSm),
                        AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.secondary,
                          onPressed: () => Navigator.of(context).maybePop(),
                          expanded: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  const Expanded(child: AppTextTitle('Name')),
                  Row(
                    children: [
                      AppTextBody(_displayName),
                      const SizedBox(width: ADSSpacing.spaceLg),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),

            // ============ 邮箱项 ============
            const SizedBox(height: ADSSpacing.spaceSm),
            AppCard(
              onTap: () {
                // TODO: 编辑邮箱
              },
              child: Row(
                children: [
                  const Expanded(child: AppTextTitle('Email')),
                  Row(
                    children: const [
                      AppTextBody('john.doe@example.com'),
                      SizedBox(width: ADSSpacing.spaceLg),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
            ),

            // ============ 订阅卡片 ============
            const SizedBox(height: ADSSpacing.spaceLg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _successColor(brightness),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: ADSSpacing.spaceSm),
                                const AppTextSubtitle('Free Plan'),
                              ],
                            ),
                            const SizedBox(height: ADSSpacing.spaceXs),
                            const AppTextCaption('Current subscription'),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'Upgrade',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const UpgradePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: ADSSpacing.spaceLg),

                  // 订阅特性子块
                  Container(
                    decoration: BoxDecoration(
                      color: cs.secondary.withOpacity(0.3),
                      borderRadius: ADSRadius.radiusLg,
                    ),
                    padding: const EdgeInsets.all(ADSSpacing.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.trending_up, size: 16, color: cs.primary),
                            const SizedBox(width: ADSSpacing.spaceSm),
                            const AppTextBody('Plan Features'),
                          ],
                        ),
                        const SizedBox(height: ADSSpacing.spaceMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppTextBody('Recording Duration'),
                            Container(
                              decoration: BoxDecoration(
                                color: cs.primary.withOpacity(0.12),
                                borderRadius: ADSRadius.radiusMd,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: ADSSpacing.spaceLg,
                                vertical: ADSSpacing.spaceXs,
                              ),
                              child: Text(
                                '1 minute per session',
                                style: ADSTypography.caption.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ADSSpacing.spaceXs),
                        const AppTextCaption('Maximum length for each recording'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ============ 设置分组 ============
            const SizedBox(height: ADSSpacing.spaceXl),
            const AppTextSubtitle('Settings'),
            const SizedBox(height: ADSSpacing.spaceSm),
            _SettingsItem(
              icon: Icons.cloud_outlined,
              iconBg: cs.secondary,
              iconColor: ADSColors.lightButtonPrimary,
              title: 'Cloud Sync',
              subtitle: 'Sync notes across devices',
              trailing: Switch(
                value: true,
                onChanged: null, // TODO: 开启/关闭云同步
              ),
            ),
            const SizedBox(height: ADSSpacing.spaceSm),
            _SettingsItem(
              icon: Icons.shield_outlined,
              iconBg: cs.secondary,
              iconColor: ADSColors.lightButtonPrimary,
              title: 'Privacy Settings',
              subtitle: 'Manage data and privacy',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacySettingsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: ADSSpacing.spaceSm),
            _SettingsItem(
              icon: Icons.help_outline,
              iconBg: cs.secondary,
              iconColor: ADSColors.lightButtonPrimary,
              title: 'Help & Feedback',
              subtitle: 'Get help or send feedback',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HelpFeedbackPage(),
                  ),
                );
              },
            ),

            // ============ 更多分组 ============
            const SizedBox(height: ADSSpacing.spaceXl),
            const AppTextSubtitle('More'),
            const SizedBox(height: ADSSpacing.spaceSm),
            _SettingsItem(
              icon: Icons.delete_outline,
              iconBg: _errorColor(brightness).withOpacity(0.12),
              iconColor: _errorColor(brightness),
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 删除账号确认
              },
            ),
            const SizedBox(height: ADSSpacing.spaceSm),
            _SettingsItem(
              icon: Icons.logout,
              iconBg: _warningColor(brightness).withOpacity(0.12),
              iconColor: _warningColor(brightness),
              title: 'Logout',
              subtitle: 'Sign out of your account',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 退出登录确认
              },
            ),

            // ============ 版本信息 ============
            const SizedBox(height: ADSSpacing.spaceXl),
            const Divider(
              color: ADSColors.lightDivider,
            ),
            const SizedBox(height: ADSSpacing.spaceLg),
            Center(
              child: Column(
                children: const [
                  AppTextBody('Voice Notes App'),
                  SizedBox(height: ADSSpacing.spaceXs),
                  AppTextCaption('Version 1.0.0 (Build 2024.1.1)'),
                  SizedBox(height: ADSSpacing.spaceXs),
                  AppTextCaption('© 2024 Voice Notes. All rights reserved.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 单行设置项（卡片壳）
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: ADSRadius.radiusMd,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: ADSSpacing.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTitle(
                  title,
                
               
                  ),
               
                const SizedBox(height: 4),
                AppTextBody(subtitle),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}


