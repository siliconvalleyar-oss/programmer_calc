import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../engine/calculator_engine.dart';

class VariablesScreen extends StatefulWidget {
  final CalculatorEngine engine;

  const VariablesScreen({super.key, required this.engine});

  @override
  State<VariablesScreen> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends State<VariablesScreen> {
  late Set<String> _builtins;

  @override
  void initState() {
    super.initState();
    _builtins = {'PI', 'E'};
  }

  @override
  Widget build(BuildContext context) {
    final vars = Map<String, num>.from(widget.engine.variables);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(title: const Text('Variables')),
      body: vars.isEmpty
          ? const Center(
              child: Text('No variables defined', style: TextStyle(color: AppTheme.textDim)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: vars.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final entry = vars.entries.elementAt(index);
                final isBuiltin = _builtins.contains(entry.key);
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.textDim.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: isBuiltin ? AppTheme.hexColor : AppTheme.accentTeal,
                          fontSize: 15,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '= ${entry.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
