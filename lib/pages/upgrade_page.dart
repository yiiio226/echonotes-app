// Mapping Note:
// TSX → Flutter 映射说明
// - 页面结构：将 React 组件映射为 StatefulWidget，useState 映射为 setState
// - 新组件：新增 AppBadge 组件用于"Best Value"等标签显示
// - 布局：使用 Scaffold + SingleChildScrollView + Column 实现页面结构
// - 底部固定区：使用 bottomNavigationBar 实现固定在底部的计费选项
// - 交互：保留 monthly/yearly 切换逻辑，支付按钮交互留 TODO

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_button.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_badge.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  // 计费周期选择 (monthly/yearly)
  String _billingCycle = 'yearly';

  // 构建特性列表项
  List<Widget> _buildFeaturesList() {
    final features = [
      "Unlimited recording duration",
      "Unlimited recordings and total time",
      "High-quality transcription (optimized speech, removed filler words)",
      "Smart summaries (bullet points, to-do lists, study cards, diary style)",
      "Unlimited automatic note associations (keyword/semantic matching)",
      "Multi-device sync (phone/tablet/web)",
      "Note export (PDF, Markdown)",
      "Priority support and feature updates",
    ];
    
    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: ADSSpacing.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: ADSSpacing.spaceMd),
          Expanded(
            child: AppTextBody(feature),
          ),
        ],
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTextSubtitle('Upgrade Plan'),
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
          children: [
            // ============ 头部区域 ============
            Center(
              child: Column(
                children: [
                  // 皇冠图标容器
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cs.primary,
                          cs.primary.withOpacity(0.6),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: ADSSpacing.spaceLg),
                  const AppTextHeadline(
                    'Unlock Premium Features',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ADSSpacing.spaceSm),
                  const AppTextBody(
                    'Choose the plan that best fits your recording needs',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceXl),
            
            // ============ Pro 计划卡片 ============
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Pro 计划卡片
                AppCard(
                  padding: const EdgeInsets.all(ADSSpacing.spaceXl),
                  child: Column(
                    children: [
                      // 卡片标题区域
                      Column(
                        children: [
                          const SizedBox(height: ADSSpacing.spaceLg),
                          const AppTextSubtitle('Pro'),
                          const SizedBox(height: ADSSpacing.spaceSm),
                          
                          // 价格显示
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _billingCycle == 'yearly' ? '\$37.99' : '\$4.99',
                                style: ADSTypography.h1.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AppTextBody(
                                _billingCycle == 'yearly' ? '/year' : '/month',
                              ),
                            ],
                          ),
                          
                          // 年付优惠提示
                          if (_billingCycle == 'yearly') ...[
                            const SizedBox(height: ADSSpacing.spaceXs),
                            Text(
                              'Equivalent to \$3.17/month, save 25%',
                              style: ADSTypography.caption.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: ADSSpacing.spaceSm),
                          const AppTextBody(
                            'For students, researchers, professionals, and creators',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: ADSSpacing.spaceXl),
                      
                      // 特性列表
                      ..._buildFeaturesList(),
                    ],
                  ),
                ),
                
                // "Best Value" 标签
                Positioned(
                  top: -12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AppBadge(
                      label: 'Best Value',
                      icon: Icons.bolt,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 100), // 底部空间，避免被固定底栏遮挡
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // 构建底部固定的计费选项区域
  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brightness = theme.brightness;
    
    // 边框颜色
    final borderColor = brightness == Brightness.dark
        ? ADSColors.darkDivider
        : ADSColors.lightDivider;
    
    // 选中项背景色
    final selectedBgColor = cs.primary.withOpacity(0.05);
    
    return Container(
      padding: const EdgeInsets.all(ADSSpacing.spaceLg),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============ 月付选项 ============
            GestureDetector(
              onTap: () => setState(() => _billingCycle = 'monthly'),
              child: Container(
                padding: const EdgeInsets.all(ADSSpacing.spaceLg),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _billingCycle == 'monthly' ? cs.primary : borderColor,
                    width: 2,
                  ),
                  borderRadius: ADSRadius.radiusLg,
                  color: _billingCycle == 'monthly' ? selectedBgColor : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppTextTitle('Monthly Plan'),
                        SizedBox(height: 2),
                        AppTextBody('\$4.99/month'),
                      ],
                    ),
                    _buildRadioButton(_billingCycle == 'monthly'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceLg),
            
            // ============ 年付选项 ============
            GestureDetector(
              onTap: () => setState(() => _billingCycle = 'yearly'),
              child: Container(
                padding: const EdgeInsets.all(ADSSpacing.spaceLg),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _billingCycle == 'yearly' ? cs.primary : borderColor,
                    width: 2,
                  ),
                  borderRadius: ADSRadius.radiusLg,
                  color: _billingCycle == 'yearly' ? selectedBgColor : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppTextTitle('Yearly Plan'),
                        const SizedBox(height: 2),
                        const AppTextBody('\$37.99/year'),
                        const SizedBox(height: 2),
                        Text(
                          'Save 25% • \$3.17/month',
                          style: ADSTypography.caption.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppBadge(
                          label: 'Save 35%',
                          variant: AppBadgeVariant.primary,
                        ),
                        const SizedBox(width: ADSSpacing.spaceMd),
                        _buildRadioButton(_billingCycle == 'yearly'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: ADSSpacing.spaceXl),
            
            // ============ 升级按钮 ============
            AppButton(
              label: 'Upgrade to Pro - ${_billingCycle == 'yearly' ? '\$37.99/year' : '\$4.99/month'}',
              onPressed: () {
                // TODO: 集成支付功能
              },
              expanded: true,
            ),
            const SizedBox(height: ADSSpacing.spaceSm),
            const AppTextCaption('Cancel anytime. No commitment.'),
          ],
        ),
      ),
    );
  }
  
  // 自定义单选按钮
  Widget _buildRadioButton(bool isSelected) {
    final cs = Theme.of(context).colorScheme;
    
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? cs.primary : ADSColors.lightTextSecondary,
          width: 2,
        ),
        color: isSelected ? cs.primary : null,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}
