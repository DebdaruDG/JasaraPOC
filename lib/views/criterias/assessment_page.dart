import 'dart:developer' as console;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/api/api_response.dart';
import '../../models/response/evaluate_response_model.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/criteria_provider.dart';
import '../../providers/screen_switch_provider.dart';
import '../../widgets/top_score_pie_chart.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (_isInitialized) return;
    _isInitialized = true;
    console.log('initState called for AssessmentPage');

    try {
      final criteriaVM = Provider.of<CriteriaProvider>(context, listen: false);
      final assessmentVM = Provider.of<AssessmentProvider>(
        context,
        listen: false,
      );
      Future.delayed(Duration.zero, () async {
        if (!mounted) return;
        await assessmentVM.setCriteriaCount(0);
        assessmentVM.clearEvaluateResponses();
        await criteriaVM.fetchCriteriaList();
        if (!mounted) return;

        console.log(
          'Criteria list: ${criteriaVM.criteriaListResponse.map((c) => c.assistantId).toList()}',
        );

        await assessmentVM.setCriteriaCount(
          criteriaVM.criteriaListResponse.length,
        );

        List<String> descriptions = [];

        for (var item in criteriaVM.criteriaListResponse) {
          if (!mounted) return;
          console.log(
            'Starting evaluation for criteriaId: ${item.assistantId}',
          );
          await assessmentVM.evaluateBE(
            widget.formJson ?? {},
            item.assistantId,
            widget.file!,
          );

          if (assessmentVM.evaluateResponses.isNotEmpty) {
            for (var response in assessmentVM.evaluateResponses) {
              if (response.results.isNotEmpty &&
                  !descriptions.contains(response.results[0].summary)) {
                descriptions.add(response.results[0].summary);
              }
            }
          }

          console.log(
            'Completed evaluation for criteriaId: ${item.assistantId}, Total completed: ${assessmentVM.evaluateResponses.length}, Total criteria: ${assessmentVM.criteriaCount}',
          );
        }

        if (!mounted) return;
        await assessmentVM.evaluateCriteriaSummary(descriptions);
        console.log(
          'Final evaluateResponses: ${assessmentVM.evaluateResponses.map((r) => r.results.map((res) => res.assistantId).toList()).toList()}',
        );

        if (assessmentVM.evaluateResponses.length ==
            criteriaVM.criteriaListResponse.length) {
          var uuid = Uuid();
          await assessmentVM.saveEvaluationAsRFI(
            id: uuid.v4(),
            title: 'Evaluation Summary',
            comment: 'Summary of all criteria evaluations',
            fileName: widget.file?.name ?? 'evaluation.pdf',
            fileUrl:
                'data:application/pdf;base64,${widget.file?.toString() ?? ''}',
            percentage: assessmentVM.averageScore,
            result: assessmentVM.averageScore >= 70 ? 'GO' : 'NO GO',
          );
          console.log('Evaluation saved to Firebase');
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
            body: Consumer2<AssessmentProvider, CriteriaProvider>(
              builder: (context, assessmentProvider, criteriaProvider, _) {
                final total = criteriaProvider.criteriaListResponse.length;
                final completed = assessmentProvider.evaluateResponses.length;
                final isLoading =
                    assessmentProvider.evaluateResponse.status ==
                    Status.loading;
                console.log(
                  'assessmentProvider.criteriaSummary.data?.summary :- ${assessmentProvider.criteriaSummary.data?.summary}',
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopScorePieChart(
                        criteriaList: criteriaProvider.criteriaListResponse,
                        evaluateResponses: assessmentProvider.evaluateResponses,
                        averageScore: assessmentProvider.averageScore,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            assessmentProvider.criteriaSummary.status ==
                                    Status.loading
                                ? Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: JasaraPalette.deepIndigo,
                                        strokeWidth: 1.25,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Evaluating...'),
                                  ],
                                )
                                : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "${assessmentProvider.criteriaSummary.data?.summary}",
                                    maxLines: 8,
                                    style: JasaraTextStyles.primaryText500
                                        .copyWith(
                                          fontSize: 13,
                                          color: JasaraPalette.dark2,
                                        ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Evaluating $completed of $total Criterias",
                            style: JasaraTextStyles.primaryText500.copyWith(
                              fontSize: 16,
                              color: JasaraPalette.dark2,
                            ),
                          ),
                          Text(
                            'Average Score : ${(assessmentProvider.averageScore / 10).toStringAsFixed(2)}',
                            style: JasaraTextStyles.primaryText500.copyWith(
                              fontSize: 16,
                              color: JasaraPalette.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              assessmentProvider.evaluateResponse.status ==
                                      Status.loading
                                  ? null
                                  : () {
                                    Navigator.pop(context);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: JasaraPalette.accent,
                            foregroundColor: JasaraPalette.dark2,
                          ),
                          child: Text('Accept Decision'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(total, (index) {
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
                      }),
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
        color: Colors.white,
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
          if (hasData) ...[
            Text(
              "Score: ${((model?.results[0].score ?? 0) / 10).toStringAsFixed(2)} / 10",
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 14,
                color: JasaraPalette.primary,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: (model?.results[0].score ?? 0) / 10,
                backgroundColor: JasaraPalette.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  JasaraPalette.deepIndigo,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSparkleLoader({Widget? child}) {
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
                children: [
                  const Icon(Icons.auto_awesome, color: JasaraPalette.primary),
                  const SizedBox(width: 8),
                  child ??
                      const Text(
                        "Thinking...",
                        style: JasaraTextStyles.primaryText400,
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
