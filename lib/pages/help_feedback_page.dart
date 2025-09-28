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
              question: 'How to record longer voice notes?',
              answer:
                  'The free plan limits each recording to 1 minute. Upgrade to Pro to enjoy unlimited recording duration and unlock more advanced features.',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: 'How to export my notes?',
              answer:
                  'Pro users can export notes as PDF or Markdown format. In the note details page, tap the "More" menu and select "Export" option.',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: 'How to sync to other devices?',
              answer:
                  'Pro plan supports multi-device sync. Make sure to log in with the same account on all devices, and your notes will sync automatically.',
            ),
            SizedBox(height: ADSSpacing.spaceSm),
            _buildFaqItem(
              question: 'What languages does speech recognition support?',
              answer:
                  'Currently supports over 20 major languages including Chinese, English, Japanese, etc. The system will automatically detect your system language, or you can manually select your preferred language in settings.',
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
              'We value your feedback greatly as it helps us continuously improve our product. Please share your thoughts, suggestions, or any issues you encounter.',
            ),
            const SizedBox(height: ADSSpacing.spaceLg),
            
            TextField(
              controller: _feedbackCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Please enter your feedback...',
                contentPadding: const EdgeInsets.all(ADSSpacing.spaceLg),
                border: OutlineInputBorder(
                  borderRadius: ADSRadius.radiusLg,
                ),
              ),
            ),
            const SizedBox(height: ADSSpacing.spaceLg),
            
            AppButton(
              label: _isSubmitting ? 'Submitting...' : 'Submit Feedback',
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
            content: Text(
                'Thank you for your feedback! We will carefully consider your suggestions.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission failed, please try again later.'),
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
