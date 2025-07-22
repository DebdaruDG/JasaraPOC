import 'dart:developer' as console;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/api/api_response.dart';
import '../../core/utils/file_utils.dart';
import '../../models/response/criteria_summary_response_model.dart';
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

        // Validate input
        if (widget.file == null || widget.formJson == null) {
          console.log('Invalid input: file or formJson is null');
          return;
        }

        // Create a list of futures for parallel evaluation
        final evaluationFutures =
            criteriaVM.criteriaListResponse.map((item) {
              console.log(
                'Starting evaluation for criteriaId: ${item.assistantId} at ${DateTime.now()}',
              );
              return assessmentVM.evaluateBE(
                widget.formJson!,
                item.assistantId,
                widget.file!,
              );
            }).toList();

        // Execute all evaluations in parallel
        await Future.wait(evaluationFutures, eagerError: true);

        if (!mounted) return;

        // Collect summaries from responses
        List<String> descriptions = [];
        for (var response in assessmentVM.evaluateResponses) {
          if (response.results.isNotEmpty &&
              !descriptions.contains(response.results[0].summary)) {
            descriptions.add(response.results[0].summary);
          }
        }

        console.log(
          'Collected ${descriptions.length} unique descriptions: $descriptions',
        );

        // Summarize criteria only if descriptions are available
        if (descriptions.isNotEmpty) {
          console.log('Calling evaluateCriteriaSummary at ${DateTime.now()}');
          await assessmentVM.evaluateCriteriaSummary(descriptions);
          console.log(
            'evaluateCriteriaSummary completed at ${DateTime.now()}, criteriaSummary: ${assessmentVM.criteriaSummary.data?.summary}',
          );
        } else {
          console.log(
            'No valid descriptions to summarize, skipping summarizer API call',
          );
          assessmentVM.setCriteriaSummary(
            ApiResponse.completed(
              CriteriaSummaryResponseModel(
                summary: 'No valid summaries available',
              ),
            ),
          );
        }

        console.log(
          'Completed all evaluations. Total completed: ${assessmentVM.evaluateResponses.length}, Total criteria: ${assessmentVM.criteriaCount}',
        );

        console.log(
          'Final evaluateResponses: ${assessmentVM.evaluateResponses.map((r) => r.results.map((res) => res.assistantId).toList()).toList()}',
        );

        // Save evaluation as RFI if all responses are received
        if (assessmentVM.evaluateResponses.length ==
            criteriaVM.criteriaListResponse.length) {
          console.log('save formJson :- ${widget.formJson}');
          console.log(
            'save assessmentVM.criteriaSummary.data?.summary :- ${assessmentVM.criteriaSummary.data?.summary}',
          );
          console.log(
            "save assessmentVM.averageScore :- ${assessmentVM.averageScore}",
          );
          console.log(
            'save size :- ${widget.file?.size} \truntimeType :- ${widget.file?.runtimeType} \tname - ${widget.file?.name}',
          );
          var uuid = Uuid();
          var base64FileContent = await FileUtils.fileToBase64(widget.file!);
          var title =
              widget.formJson?.containsKey('project_name') == true
                  ? widget.formJson!['project_name']
                  : 'Some Project';
          console.log('title - $title');
          await assessmentVM.saveEvaluationAsRFI(
            id: uuid.v4(),
            title: title,
            comment: assessmentVM.criteriaSummary.data?.summary ?? '',
            fileName: widget.file?.name ?? 'evaluation.pdf',
            fileUrl: base64FileContent,
            percentage: assessmentVM.averageScore,
            result: assessmentVM.averageScore >= 70 ? 'GO' : 'NO GO',
          );
          console.log('Evaluation saved to Firebase');
        }
      });
    } catch (exc) {
      console.log('Exception in initState: $exc');
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
                                ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      Text('Summarizing...'),
                                    ],
                                  ),
                                )
                                : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "${assessmentProvider.criteriaSummary.data?.summary}",
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

                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              assessmentProvider.evaluateResponse.status ==
                                      Status.loading
                                  ? null
                                  : () async {
                                    final screenSwitchProvider =
                                        Provider.of<ScreenSwitchProvider>(
                                          context,
                                          listen: false,
                                        );
                                    screenSwitchProvider.toggleAssessment(
                                      false,
                                    );
                                    Navigator.pop(context);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: JasaraPalette.mintGreen,
                            foregroundColor: JasaraPalette.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Accept Decision',
                              style: JasaraTextStyles.primaryText500.copyWith(
                                fontWeight: FontWeight.w700,
                                color: JasaraPalette.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Average Score :  ",
                                  style: JasaraTextStyles.primaryText500
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.1,
                                        color: JasaraPalette.deepIndigo,
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      '${(assessmentProvider.averageScore / 10).toStringAsFixed(2)} / ${10}',
                                  style: JasaraTextStyles.primaryText500
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.1,
                                        color: JasaraPalette.dark2,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    if (hasData) {
      console.log('model.results[0].score :- ${model.results[0].score}');
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                criteriaLabel,
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 16,
                  color: JasaraPalette.dark2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasData)
                Text(
                  "${((model.results[0].score) / 10).toStringAsFixed(2)} / 10",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 16,
                    color: JasaraPalette.dark1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: (model.results[0].score) / 100,
                backgroundColor: JasaraPalette.grey.withOpacity(0.25),
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
