import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_card.dart';

/// 隐私设置页面
///
/// 包含：
/// - 数据收集与使用说明
/// - 隐私选项开关
/// - 数据导出/删除操作
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  // 隐私选项状态
  bool _collectUsageData = true;
  bool _personalization = true;
  bool _crashReports = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brightness = theme.brightness;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppTextSubtitle('Privacy Settings'),
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
            // ============ 隐私说明 ============
            Container(
              padding: const EdgeInsets.all(ADSSpacing.spaceLg),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                borderRadius: ADSRadius.radiusLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppTextTitle('Your Privacy Matters'),
                  SizedBox(height: ADSSpacing.spaceSm),
                  AppTextBody(
                    'We value your privacy and give you control over how your data is used. '
                    'You can customize your privacy settings below.',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceXl),
            const AppTextSubtitle('Data Collection'),
            const SizedBox(height: ADSSpacing.spaceSm),
            
            // ============ 数据收集选项 ============
            _buildPrivacySwitch(
              title: 'Usage Statistics',
              subtitle: 'Help us improve by sharing anonymous usage data',
              value: _collectUsageData,
              onChanged: (value) {
                setState(() => _collectUsageData = value);
              },
            ),
            
            const SizedBox(height: ADSSpacing.spaceSm),
            _buildPrivacySwitch(
              title: 'Personalization',
              subtitle: 'Allow us to personalize your experience based on your usage',
              value: _personalization,
              onChanged: (value) {
                setState(() => _personalization = value);
              },
            ),
            
            const SizedBox(height: ADSSpacing.spaceSm),
            _buildPrivacySwitch(
              title: 'Crash Reports',
              subtitle: 'Send anonymous crash reports to help fix issues',
              value: _crashReports,
              onChanged: (value) {
                setState(() => _crashReports = value);
              },
            ),
            
            const SizedBox(height: ADSSpacing.spaceXl),
            const AppTextSubtitle('Your Data'),
            const SizedBox(height: ADSSpacing.spaceSm),
            
            // ============ 数据导出/删除 ============
            AppCard(
              onTap: () {
                // TODO: 导出用户数据功能
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cs.secondary,
                      borderRadius: ADSRadius.radiusMd,
                    ),
                    child: Icon(
                      Icons.download_outlined,
                      color: brightness == Brightness.dark 
                          ? ADSColors.darkButtonPrimary 
                          : ADSColors.lightButtonPrimary,
                    ),
                  ),
                  const SizedBox(width: ADSSpacing.spaceLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppTextTitle('Export Your Data'),
                        SizedBox(height: 4),
                        AppTextBody('Download a copy of your data'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceSm),
            AppCard(
              onTap: () {
                _showDeleteDataConfirmation();
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _errorColor(brightness).withOpacity(0.12),
                      borderRadius: ADSRadius.radiusMd,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: _errorColor(brightness),
                    ),
                  ),
                  const SizedBox(width: ADSSpacing.spaceLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppTextTitle('Delete Your Data'),
                        SizedBox(height: 4),
                        AppTextBody('Permanently delete your data from our servers'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            
            // ============ 隐私政策链接 ============
            const SizedBox(height: ADSSpacing.spaceXl),
            const Divider(),
            const SizedBox(height: ADSSpacing.spaceLg),
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: 打开隐私政策
                },
                child: const AppTextBody(
                  'View Privacy Policy',
                  color: ADSColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建隐私设置开关项
  Widget _buildPrivacySwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTitle(title),
                const SizedBox(height: 4),
                AppTextBody(subtitle),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
  
  // 删除数据确认对话框
  Future<void> _showDeleteDataConfirmation() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppTextSubtitle('Delete Your Data?'),
        content: const AppTextBody(
          'This action will permanently delete all your data from our servers. '
          'This cannot be undone. Are you sure you want to proceed?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 删除用户数据
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: _errorColor(Theme.of(context).brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 获取错误色（深浅色适配）
  Color _errorColor(Brightness b) =>
      b == Brightness.dark ? ADSColors.darkError : ADSColors.lightError;
}
