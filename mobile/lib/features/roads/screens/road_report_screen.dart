// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Road Report Screen (Photo Upload + AI Analysis)

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';

class RoadReportScreen extends StatefulWidget {
  const RoadReportScreen({super.key});

  @override
  State<RoadReportScreen> createState() => _RoadReportScreenState();
}

class _RoadReportScreenState extends State<RoadReportScreen> {
  bool _hasPhoto = false;
  bool _isAnalyzing = false;
  bool _showResults = false;
  DefectType? _detectedType;
  final _descriptionController = TextEditingController();

  void _simulateCapture() async {
    setState(() { _hasPhoto = true; _isAnalyzing = true; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _showResults = true;
        _detectedType = DefectType.pothole;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Report Road Issue')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo area
            GestureDetector(
              onTap: _hasPhoto ? null : _simulateCapture,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _hasPhoto ? AppColors.ghanaGreen.withValues(alpha: 0.3) : AppColors.ghanaGold.withValues(alpha: 0.3), width: 2, style: _hasPhoto ? BorderStyle.solid : BorderStyle.solid),
                ),
                child: _hasPhoto
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade700]),
                            ),
                            child: Center(child: Icon(Icons.add_road, size: 64, color: Colors.white.withValues(alpha: 0.3))),
                          ),
                          if (_isAnalyzing) ...[
                            Container(
                              color: Colors.black54,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 60, height: 60,
                                    child: CircularProgressIndicator(color: AppColors.ghanaGold, strokeWidth: 3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('Running on-device CNN...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text('Detecting defects with TFLite', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                          if (_showResults) ...[
                            Positioned(
                              top: 8, right: 8,
                              child: StatusBadge(label: 'POTHOLE DETECTED', color: AppColors.ghanaRed),
                            ),
                            Positioned(
                              bottom: 8, right: 8,
                              child: StatusBadge(label: '94% AI Confidence', color: AppColors.ghanaGreen),
                            ),
                          ],
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 48, color: AppColors.ghanaGold),
                          const SizedBox(height: 12),
                          Text('Take or upload a road photo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ghanaGold)),
                          const SizedBox(height: 4),
                          Text('AI detects potholes, cracks, erosion, flooding', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        ],
                      ),
              ),
            ),

            if (_showResults) ...[
              const SizedBox(height: 16),

              // AI Detection Results
              GlassCard(
                borderColor: AppColors.ghanaGold.withValues(alpha: 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.ghanaGold),
                        const SizedBox(width: 8),
                        Text('AI Detection Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DetectionResult(label: 'Defect Type', value: 'Pothole', color: AppColors.ghanaRed),
                    _DetectionResult(label: 'Severity', value: 'HIGH – 60cm diameter, 15cm depth', color: AppColors.ghanaRed),
                    _DetectionResult(label: 'Road Condition', value: 'Poor', color: AppColors.roadPoor),
                    _DetectionResult(label: 'Time to Failure', value: '~30 days without repair', color: AppColors.warning),
                    _DetectionResult(label: 'Climate Risk', value: 'HIGH – Rainfall will accelerate', color: AppColors.ghanaRed),
                    _DetectionResult(label: 'Est. Repair Cost', value: 'GH₵ 2,500', color: AppColors.ghanaGreen),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location
              Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.ghanaGold),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Auto-detected via GPS', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          Text('N1 Highway, Tetteh Quarshie, Accra', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Additional details (optional)',
                  hintText: 'Describe what you see...',
                  alignLabelWithHint: true,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _showResults ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Report submitted! 🇬🇭 Thank you for helping Ghana.'),
                      backgroundColor: AppColors.ghanaGreen,
                    ),
                  );
                  Navigator.pop(context);
                } : null,
                icon: Icon(Icons.send),
                label: Text('Submit Report'),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _DetectionResult extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DetectionResult({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color))),
        ],
      ),
    );
  }
}
