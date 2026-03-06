// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Technician Photo Workflow Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class TechnicianWorkflowScreen extends StatefulWidget {
  const TechnicianWorkflowScreen({super.key});

  @override
  State<TechnicianWorkflowScreen> createState() => _TechnicianWorkflowScreenState();
}

class _TechnicianWorkflowScreenState extends State<TechnicianWorkflowScreen> {
  bool _hasPhoto = false;
  bool _isAnalyzing = false;
  bool _showResults = false;

  void _simulatePhotoCapture() async {
    setState(() { _hasPhoto = true; _isAnalyzing = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() { _isAnalyzing = false; _showResults = true; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Workflow'),
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo capture area
            GlassCard(
              child: Column(
                children: [
                  if (!_hasPhoto) ...[
                    GestureDetector(
                      onTap: _simulatePhotoCapture,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBg : AppColors.lightBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.ghanaGold.withValues(alpha: 0.3), style: BorderStyle.solid, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, size: 48, color: AppColors.ghanaGold),
                            const SizedBox(height: 12),
                            Text('Tap to capture equipment photo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ghanaGold)),
                            const SizedBox(height: 4),
                            Text('AI will instantly classify the fault', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade700, Colors.grey.shade800],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.electrical_services, size: 64, color: Colors.white.withValues(alpha: 0.3)),
                          if (_isAnalyzing)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(color: AppColors.ghanaGold),
                                    const SizedBox(height: 12),
                                    Text('AI Analyzing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          if (_showResults)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: StatusBadge(label: '94% Confidence', color: AppColors.ghanaGreen),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (_showResults) ...[
              const SizedBox(height: 16),

              // AI Classification Result
              GlassCard(
                borderColor: AppColors.ghanaGold.withValues(alpha: 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.ghanaGold, size: 20),
                        const SizedBox(width: 8),
                        Text('AI Classification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ResultItem(label: 'Equipment', value: 'Distribution Transformer', icon: Icons.settings),
                    _ResultItem(label: 'Fault Type', value: 'Oil Leak + Overheating', icon: Icons.warning_amber),
                    _ResultItem(label: 'Severity', value: 'HIGH – Immediate attention', icon: Icons.priority_high, valueColor: AppColors.ghanaRed),
                    _ResultItem(label: 'Estimated Repair', value: '4-6 hours', icon: Icons.timer),
                    _ResultItem(label: 'Cost Estimate', value: 'GH₵ 8,500 – 12,000', icon: Icons.payments),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Repair Checklist
              Text('Repair Checklist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    _ChecklistItem(step: 1, text: 'De-energize transformer and isolate', isDone: false),
                    _ChecklistItem(step: 2, text: 'Inspect oil level and take sample', isDone: false),
                    _ChecklistItem(step: 3, text: 'Check for visible leaks at gaskets', isDone: false),
                    _ChecklistItem(step: 4, text: 'Test winding resistance', isDone: false),
                    _ChecklistItem(step: 5, text: 'Replace faulty gasket/seal', isDone: false),
                    _ChecklistItem(step: 6, text: 'Refill transformer oil', isDone: false),
                    _ChecklistItem(step: 7, text: 'Re-energize and monitor for 2 hours', isDone: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share),
                      label: Text('Share Report'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.assignment_add),
                      label: Text('Create Work Order'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _ResultItem({required this.label, required this.value, required this.icon, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.ghanaGold),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatefulWidget {
  final int step;
  final String text;
  final bool isDone;
  const _ChecklistItem({required this.step, required this.text, required this.isDone});

  @override
  State<_ChecklistItem> createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<_ChecklistItem> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _isDone = !_isDone),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isDone ? AppColors.ghanaGreen : Colors.transparent,
                border: Border.all(color: _isDone ? AppColors.ghanaGreen : Colors.grey),
              ),
              child: _isDone ? Icon(Icons.check, size: 16, color: Colors.white) : Center(child: Text('${widget.step}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14,
                  decoration: _isDone ? TextDecoration.lineThrough : null,
                  color: _isDone ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
