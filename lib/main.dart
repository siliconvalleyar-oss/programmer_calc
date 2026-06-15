import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'screens/basic_screen.dart';

void main() {
  runApp(const PcalcApp());
}

class PcalcApp extends StatelessWidget {
  const PcalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCALC - Programmer\'s Calculator',
      debugShowCheckedModeBanner: false,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _programmerMode = true;

  void _toggleMode() {
    setState(() => _programmerMode = !_programmerMode);
  }

  @override
  Widget build(BuildContext context) {
    if (_programmerMode) {
      return HomeScreen(onToggleMode: _toggleMode);
    }
    return BasicScreen(onToggleMode: _toggleMode);
  }
}
