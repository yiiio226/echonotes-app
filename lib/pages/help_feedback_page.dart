import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_button.dart';

/// 帮助与反馈页面
///
/// 包含：
/// - 常见问题 (FAQ) 部分
/// - 联系支持团队
/// - 提交反馈表单
class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  State<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  final TextEditingController _feedbackCtrl = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brightness = theme.brightness;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppTextSubtitle('Help & Feedback'),
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
            // ============ 常见问题 ============
            const AppTextSubtitle('Frequently Asked Questions'),
            const SizedBox(height: ADSSpacing.spaceSm),
            
            _buildFaqItem(
              question: '如何录制更长的语音笔记？',
              answer: '免费版限制每次录音1分钟。升级到专业版可享受无限录音时长，并解锁更多高级功能。',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: '如何导出我的笔记？',
              answer: '专业版用户可以将笔记导出为PDF或Markdown格式。在笔记详情页点击"更多"菜单，然后选择"导出"选项。',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: '如何同步到其他设备？',
              answer: '专业版支持多设备同步。确保在所有设备上使用相同账号登录，您的笔记将自动同步。',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: '语音识别支持哪些语言？',
              answer: '目前支持中文、英语、日语等20多种主要语言。系统会自动检测您的系统语言，或您可以在设置中手动选择首选语言。',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            const SizedBox(height: ADSSpacing.spaceXl),
            
            // ============ 联系支持 ============
            const AppTextSubtitle('Contact Support'),
            const SizedBox(height: ADSSpacing.spaceSm),
            
            AppCard(
              onTap: () {
                // TODO: 发送邮件到支持邮箱
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
                      Icons.email_outlined,
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
                        AppTextTitle('Email Support'),
                        SizedBox(height: 4),
                        AppTextBody('support@echonotes.app'),
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
                // TODO: 打开知识库网站
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
                      Icons.menu_book_outlined,
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
                        AppTextTitle('Knowledge Base'),
                        SizedBox(height: 4),
                        AppTextBody('Browse our help articles'),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceXl),
            
            // ============ 提交反馈 ============
            const AppTextSubtitle('Send Feedback'),
            const SizedBox(height: ADSSpacing.spaceSm),
            const AppTextBody(
              '我们非常重视您的反馈，它能帮助我们不断改进产品。请告诉我们您的想法、建议或遇到的问题。',
            ),
            const SizedBox(height: ADSSpacing.spaceLg),
            
            TextField(
              controller: _feedbackCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '请输入您的反馈...',
                contentPadding: const EdgeInsets.all(ADSSpacing.spaceLg),
                border: OutlineInputBorder(
                  borderRadius: ADSRadius.radiusLg,
                ),
              ),
            ),
            const SizedBox(height: ADSSpacing.spaceLg),
            
            AppButton(
              label: _isSubmitting ? '提交中...' : '提交反馈',
              onPressed: _isSubmitting ? null : _submitFeedback,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
  
  // 构建FAQ项
  Widget _buildFaqItem({required String question, required String answer}) {
    return AppCard(
      padding: const EdgeInsets.all(ADSSpacing.spaceLg),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: AppTextTitle(question),
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(
            bottom: ADSSpacing.spaceSm,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextBody(answer),
          ],
        ),
      ),
    );
  }
  
  // 提交反馈
  Future<void> _submitFeedback() async {
    final String feedback = _feedbackCtrl.text.trim();
    if (feedback.isEmpty) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      // 成功提交后清空输入框
      _feedbackCtrl.clear();
      
      // 显示成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('感谢您的反馈！我们将认真考虑您的建议。'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('提交失败，请稍后重试。'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
