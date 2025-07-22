import 'dart:html' as html;
import 'dart:developer' as console;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/services/api/api_client.dart';
import '../core/services/api/api_response.dart';
import '../core/services/backend/evaluate_service.dart' as backend;
import '../core/services/backend/evaluate_service.dart';
import '../core/services/firebase/evaluate_service.dart' as firebase;
import '../models/assessment_result.dart';
import '../models/evaluate_assessment_firebase_model.dart';
import '../models/response/criteria_summary_response_model.dart';
import '../models/response/evaluate_response_model.dart';
import '../models/rfi_model.dart';
import '../widgets/utils/app_toast.dart';

class AssessmentProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  ApiResponse<AssessmentResult> _result = ApiResponse.loading();
  ApiResponse<AssessmentResult> get result => _result;

  Future<void> submitAssessment(Map<String, dynamic> payload) async {
    _result = ApiResponse.loading();
    notifyListeners();

    final response = await _apiClient.submitAssessment(payload);
    _result = response;
    notifyListeners();
  }

  List<EvaluateResponse> _evaluateResponses = [];
  List<EvaluateResponse> get evaluateResponses => _evaluateResponses;

  final Set<String> _loadingIds = {};
  Set<String> get loadingIds => _loadingIds;

  int _totalScore = 0;
  int get totalScore => _totalScore;

  int _scoreCount = 0;
  int get scoreCount => _scoreCount;

  int _criteriaCount = 0;
  int get criteriaCount => _criteriaCount;
  setCriteriaCount(int val) {
    _criteriaCount = val;
    notifyListeners();
  }

  void clearEvaluateResponses() {
    console.log(
      'Clearing evaluateResponses. Previous length: ${_evaluateResponses.length}',
    );
    _evaluateResponses.clear();
    notifyListeners();
  }

  double get averageScore {
    if (_evaluateResponses.isEmpty) return 0.0;

    _totalScore = 0; // Reset to avoid accumulation
    _scoreCount = 0;
    for (var response in _evaluateResponses) {
      for (var result in response.results) {
        _totalScore += result.score.toInt();
        _scoreCount++;
      }
    }

    return _scoreCount > 0 ? _totalScore / _scoreCount : 0.0;
  }

  ApiResponse<EvaluateResponse> _evaluateResponse = ApiResponse.completed(null);
  ApiResponse<EvaluateResponse> get evaluateResponse => _evaluateResponse;

  Future<void> evaluateBE(
    Map<String, dynamic> formJson,
    String criteriaId,
    html.File file,
  ) async {
    console.log('evaluateBE called for criteriaId: $criteriaId');
    _loadingIds.add(criteriaId);
    notifyListeners();

    // Check if a response for this criteriaId already exists
    if (_evaluateResponses.any(
      (response) =>
          response.results.any((result) => result.assistantId == criteriaId),
    )) {
      _loadingIds.remove(criteriaId);
      console.log(
        'Response for criteriaId $criteriaId already exists, skipping evaluation.',
      );
      return;
    }

    final response = await backend.EvaluateService.submitEvaluation(
      formJson: formJson,
      criteriaId: criteriaId,
      file: file,
    );

    _loadingIds.remove(criteriaId);
    if (response.data != null && response.data!.results.isNotEmpty) {
      // Explicitly check if the assistantId from response.data.results[0] is not already in _evaluateResponses
      final newAssistantId = response.data!.results[0].assistantId;
      if (!_evaluateResponses.any(
        (existingResponse) => existingResponse.results.any(
          (result) => result.assistantId == newAssistantId,
        ),
      )) {
        _evaluateResponses.add(response.data!);
        console.log(
          'Added response for criteriaId $criteriaId (assistantId: $newAssistantId). Current responses: ${_evaluateResponses.map((r) => r.results.map((res) => res.assistantId).toList()).toList()}',
        );
        console.log(
          'Completed evaluation for criteriaId $criteriaId. Total completed: ${_evaluateResponses.length}, Total criteria: $_criteriaCount',
        );
      } else {
        console.log(
          'Duplicate response for assistantId $newAssistantId detected, not adding to _evaluateResponses.',
        );
      }
    } else {
      console.log(
        'No valid response data for criteriaId $criteriaId, not adding to _evaluateResponses.',
      );
    }
    notifyListeners();
  }

  Future<void> reset() async {
    _result = ApiResponse.loading();
    _evaluateResponse = ApiResponse.loading();
    notifyListeners();
  }

  Future<void> saveEvaluationAsRFI({
    required String id,
    required String title,
    required String comment,
    required String fileName,
    required String fileUrl,
    required double percentage,
    required String result,
  }) async {
    final rfi = RFIModel(
      id: id,
      title: title,
      comment: comment,
      fileName: fileName,
      fileUrl: fileUrl,
      percentage: percentage,
      summarizerComment: comment,
      result: result,
    );

    try {
      await firebase.EvaluateService.addEvaluateRfi(
        projectName: title,
        location: 'N/A',
        budget: 0.0,
        rfiPdfBase64: fileUrl,
        fileName: fileName,
        summarizerComment: comment,
        evaluationPercentage: percentage,
        result: result,
        evaluationResults: convertResponsesToRFIModels(_evaluateResponses),
      );
      await fetchRFIs();
    } catch (exc) {
      console.log('exc - $exc');
    }
  }

  List<EvaluateRFIModel> convertResponsesToRFIModels(
    List<EvaluateResponse> responses,
  ) {
    return responses.asMap().entries.map((entry) {
      final index = entry.key;
      final response = entry.value;

      return EvaluateRFIModel(
        id: 'rfi_$index',
        projectName: 'Project $index',
        location: 'Unknown',
        budget: 0.0,
        rfiPdf: response.document,
        evaluationResults:
            response.results.isNotEmpty ? [response.results[0]] : [],
        archived: false,
      );
    }).toList();
  }

  ApiResponse<List<RFIModel>> _rfis = ApiResponse.loading();
  ApiResponse<List<RFIModel>> get rfis => _rfis;

  setRfis(ApiResponse<List<RFIModel>> val) {
    _rfis = val;
    notifyListeners();
  }

  fetchRFIs() async {
    try {
      _rfis = ApiResponse.loading();
      final snapshot = await firebase.EvaluateService.evaluateAssessment.get();
      final value =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            return RFIModel(
              title: data['project_name'] as String? ?? 'Unknown Project',
              comment:
                  (data['evaluation_results'] as List<dynamic>?)
                      ?.map(
                        (e) =>
                            (e as Map<String, dynamic>)['summary'] as String?,
                      )
                      .where((s) => s != null)
                      .join(', ') ??
                  'AI evaluation summary',
              // fileName:
              //     (data['rfi_pdf'] as String?)?.split('/').last ??
              //     'unknown.pdf',
              fileUrl: data['rfi_pdf'] as String? ?? '',
              fileName: data['fileName'] as String? ?? '',
              result: data['result'] as String? ?? 'PENDING',
              id: id,
              summarizerComment: data['summarizerComment'] as String? ?? '',
              percentage: data['evaluationPercentage'] as double? ?? 0,
            );
          }).toList();
      setRfis(ApiResponse.completed(value));
    } catch (e) {
      console.log('Fetch RFIs error: $e');
      setRfis(ApiResponse.completed([]));
      return [];
    }
  }

  int _calculatePercentage(List<dynamic>? evaluationResults) {
    if (evaluationResults == null || evaluationResults.isEmpty) return 0;
    final scores =
        evaluationResults
            .map((e) => (e as Map<String, dynamic>)['score'] as num? ?? 0.0)
            .toList();
    if (scores.isEmpty) return 0;
    final total = scores.reduce((a, b) => a + b);
    final length = scores.length;
    return (total / length).toInt();
  }

  Future<void> updateRFI({
    required String documentId,
    String? title,
    String? comment,
    String? fileName,
    String? fileUrl,
    double? percentage,
    String? result,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['project_name'] = title;
    if (fileUrl != null) data['rfi_pdf'] = fileUrl;
    if (result != null) data['result'] = result;
    await firebase.EvaluateService.evaluateAssessment
        .doc(documentId)
        .update(data);
  }

  Future<void> deleteRFI(BuildContext context, String documentId) async {
    try {
      await firebase.EvaluateService.evaluateAssessment
          .doc(documentId)
          .delete();
      JasaraToast.success(context, 'Successfully Deleted the RFI Assessment');
    } catch (err) {
      JasaraToast.error(
        context,
        'Error Deleting the RFI with document Id - $documentId',
      );
    }
  }

  Future<void> archiveRFI(String documentId) async {
    await firebase.EvaluateService.evaluateAssessment.doc(documentId).update({
      'archived': true,
    });
  }

  ApiResponse<CriteriaSummaryResponseModel> criteriaSummary =
      ApiResponse.loading();

  setCriteriaSummary(ApiResponse<CriteriaSummaryResponseModel> val) {
    criteriaSummary = val;
    notifyListeners();
  }

  evaluateCriteriaSummary(List<String> descriptions) async {
    try {
      criteriaSummary = ApiResponse.loading();
      final value = await EvaluateService.summarizeCriteria(
        criteriaDescriptions: descriptions,
      );
      setCriteriaSummary(value);
    } catch (err) {
      console.log('error :- $err');
      setCriteriaSummary(ApiResponse.error('Error'));
    }
  }
}
