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
  ThemeMode _themeMode = ThemeMode.system; // 初始跟随系统

  void _toggleThemeMode() {
    setState(() {
      // 在 system / light / dark 三种模式间循环
      switch (_themeMode) {
        case ThemeMode.system:
          _themeMode = ThemeMode.light;
          break;
        case ThemeMode.light:
          _themeMode = ThemeMode.dark;
          break;
        case ThemeMode.dark:
          _themeMode = ThemeMode.system;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoNotes',
      theme: ADSTheme.lightTheme,
      darkTheme: ADSTheme.darkTheme,
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}

