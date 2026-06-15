import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../engine/calculator_engine.dart';

class HistoryScreen extends StatelessWidget {
  final CalculatorEngine engine;

  const HistoryScreen({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    final history = engine.history;
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(title: const Text('History')),
      body: history.isEmpty
          ? const Center(
              child: Text('No calculations yet', style: TextStyle(color: AppTheme.textDim)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = history[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.textDim.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['expression'] as String,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '= ${item['result']}',
                        style: const TextStyle(
                          color: AppTheme.accentTeal,
                          fontSize: 16,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
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
