import 'dart:developer' as console;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/response/evaluate_response_model.dart';
import '../../providers/assessment_page_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/criteria_provider.dart';
import '../../providers/screen_switch_provider.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';

class AssessmentPage extends StatefulWidget {
  final html.File? file;
  final Map<String, dynamic>? formJson;
  const AssessmentPage({super.key, required this.file, this.formJson});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  @override
  void initState() {
    super.initState();
    try {
      final criteriaVM = Provider.of<CriteriaProvider>(context, listen: false);
      final assessmentVM = Provider.of<AssessmentProvider>(
        context,
        listen: false,
      );
      Future.delayed(Duration.zero, () async {
        await assessmentVM.clearEvaluateResponses();
        await criteriaVM.fetchCriteriaList();
        for (var item in criteriaVM.criteriaListResponse) {
          assessmentVM.evaluateBE(
            widget.formJson ?? {},
            item.assistantId,
            widget.file!,
          );
        }
      });
    } catch (exc) {
      console.log('exc - $exc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenSwitchProvider>(
      builder:
          (context, screenProvider, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: JasaraPalette.accent,
              title: Text(
                "AI Assessment",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 18,
                  color: JasaraPalette.dark2,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: JasaraPalette.dark2),
                onPressed: () => screenProvider.toggleAssessment(false),
              ),
            ),
            body: Consumer2<AssessmentProvider, CriteriaProvider>(
              builder: (context, assessmentProvider, criteriaProvider, _) {
                final total = criteriaProvider.criteriaListResponse.length;
                final completed = assessmentProvider.evaluateResponses.length;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Counter: $completed of $total",
                            style: JasaraTextStyles.primaryText500.copyWith(
                              fontSize: 16,
                              color: JasaraPalette.dark2,
                            ),
                          ),
                          SparkleAnimation(
                            child: Text(
                              'Final Score - ${assessmentProvider.averageScore.toStringAsFixed(2)}',
                              style: JasaraTextStyles.primaryText500.copyWith(
                                fontSize: 16,
                                color: JasaraPalette.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: total,
                          itemBuilder: (context, index) {
                            final criteria =
                                criteriaProvider.criteriaListResponse[index];
                            final assistantId = criteria.assistantId;

                            final matchedResponse = assessmentProvider
                                .evaluateResponses
                                .firstWhere(
                                  (e) => e.results.any(
                                    (r) => r.assistantId == assistantId,
                                  ),
                                  orElse:
                                      () => EvaluateResponse(
                                        document: '',
                                        results: [],
                                      ),
                                );

                            return _buildCriteriaItem(
                              context,
                              matchedResponse,
                              index,
                              assistantId: assistantId,
                              criteriaLabel: criteria.title,
                              isLoading: assessmentProvider.loadingIds.contains(
                                assistantId,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }

  Widget _buildCriteriaItem(
    BuildContext context,
    EvaluateResponse? model,
    int index, {
    required String assistantId,
    required String criteriaLabel,
    required bool isLoading,
  }) {
    final hasData = model != null && model.results.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: JasaraPalette.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Criteria ${index + 1}: $criteriaLabel",
            style: JasaraTextStyles.primaryText500.copyWith(
              fontSize: 16,
              color: JasaraPalette.dark2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child:
                isLoading || !hasData
                    ? _buildSparkleLoader()
                    : Text(
                      model.results[0].summary.toString(),
                      style: JasaraTextStyles.primaryText400.copyWith(
                        fontSize: 14,
                        color: JasaraPalette.dark2,
                      ),
                    ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SparkleAnimation(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: JasaraPalette.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Score: ${hasData ? model.results[0].score.toString() : "--"}",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 14,
                    color: JasaraPalette.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkleLoader() {
    return SizedBox(
      height: 40,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 0.5 + 0.5 * (1 - (value - 0.5).abs() * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, color: JasaraPalette.primary),
                  SizedBox(width: 8),
                  Text("Thinking...", style: JasaraTextStyles.primaryText400),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
