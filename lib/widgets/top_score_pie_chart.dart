// ✅ Updated TopScorePieChart Widget and Updated Integration in AssessmentPage

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/response/evaluate_response_model.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';

class TopScorePieChart extends StatelessWidget {
  final List<EvaluateResponse> evaluateResponses;
  final double averageScore;
  final List criteriaList;
  final bool isLoading;

  const TopScorePieChart({
    super.key,
    required this.evaluateResponses,
    required this.averageScore,
    required this.criteriaList,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final int totalCriteria = criteriaList.length;
    final double totalScore = (totalCriteria * 10).toDouble();

    // Prevent overcount if duplicate evaluation happens
    final Map<String, double> scoresByAssistantId = {};
    for (var res in evaluateResponses) {
      for (var r in res.results) {
        scoresByAssistantId[r.assistantId] =
            double.tryParse(r.score.toString()) ?? 0.0;
      }
    }

    final double achievedScore = scoresByAssistantId.values.fold(
      0.0,
      (a, b) => a + b,
    );

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: 45,
                    sections: [
                      PieChartSectionData(
                        color: JasaraPalette.primary,
                        value: achievedScore,
                        title: '',
                        radius: 10,
                      ),
                      PieChartSectionData(
                        color: JasaraPalette.primary.withOpacity(0.2),
                        value: (totalScore - achievedScore),
                        title: '',
                        radius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? _buildLoader()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${achievedScore.toStringAsFixed(2)} / ${totalScore.toStringAsFixed(2)}",
                        style: JasaraTextStyles.primaryText500.copyWith(
                          fontSize: 18,
                          color: JasaraPalette.dark2,
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          const SizedBox(height: 12),
          if (!isLoading)
            Text(
              _getResultText(averageScore),
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 14,
                color: _getResultColor(averageScore),
              ),
            ),
        ],
      ),
    );
  }

  String _getResultText(double score) {
    if (score >= 9) return "Assessment Result: GO";
    if (score >= 7) return "Assessment Result: REVIEW";
    return "Assessment Result: NO-GO";
  }

  Color _getResultColor(double score) {
    if (score >= 9) return Colors.green;
    if (score >= 7) return Colors.orange;
    return Colors.red;
  }

  Widget _buildLoader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: JasaraPalette.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Calculating...",
          style: JasaraTextStyles.primaryText400.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
