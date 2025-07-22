// ✅ Updated TopScorePieChart Widget and Updated Integration in AssessmentPage

import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../models/response/evaluate_response_model.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../providers/assessment_provider.dart';

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
    final int totalScore = (totalCriteria * 10).toInt();

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

    return Consumer<AssessmentProvider>(
      builder:
          (_, provider, __) => Center(
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
                              color: JasaraPalette.mintGreen,
                              value: achievedScore,
                              title: '',
                              radius: 14,
                            ),
                            PieChartSectionData(
                              color: JasaraPalette.grey.withOpacity(0.125),
                              value: (totalScore - achievedScore),
                              title: '',
                              radius: 14,
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
                              "${((provider.averageScore / 100) * 10).toInt() * totalCriteria} / ${(10 * totalCriteria).toInt()}",
                              style: JasaraTextStyles.primaryText500.copyWith(
                                fontSize: 14,
                                color: JasaraPalette.dark2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!isLoading)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Assessment Result:  ",
                          style: JasaraTextStyles.primaryText500.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.1,
                            color: JasaraPalette.deepIndigo,
                          ),
                        ),
                        TextSpan(
                          text: _getResultLabel(averageScore),
                          style: JasaraTextStyles.primaryText500.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.1,
                            color: _getResultColor(averageScore),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
    );
  }

  String _getResultLabel(double score) {
    if (score >= 9) return "GO";
    if (score >= 7) return "REVIEW";
    return "NO-GO";
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
