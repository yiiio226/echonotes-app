import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/pages/home_page.dart';

void main() {
  runApp(const EchoNotesApp());
}

/// EchoNotes 应用入口
///
/// - 应用 `AppDesignSystem.lightTheme` 与 `AppDesignSystem.darkTheme`
/// - 使用内部状态保存 `ThemeMode`，通过 UI 切换明暗模式
class EchoNotesApp extends StatefulWidget {
  const EchoNotesApp({super.key});

  @override
  State<EchoNotesApp> createState() => _EchoNotesAppState();
}

class _EchoNotesAppState extends State<EchoNotesApp> {
  ThemeMode _themeMode = ThemeMode.light; // 默认使用浅色，未设置前不跟随系统

  // 预留：如需主题切换可恢复此方法

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoNotes',
      theme: ADSTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: ADSTheme.darkTheme,
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}

