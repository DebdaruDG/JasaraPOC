import 'dart:html' as html;
import 'dart:developer' as console;

import 'package:flutter/foundation.dart';
import '../core/services/api/api_client.dart';
import '../core/services/api/api_response.dart';
import '../core/services/backend/evaluate_service.dart' as backend;
import '../core/services/firebase/evaluate_service.dart' as firebase;
import '../models/assessment_result.dart';
import '../models/evaluate_assessment_firebase_model.dart';
import '../models/response/evaluate_response_model.dart';
import '../models/rfi_model.dart';

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

  clearEvaluateResponses() {
    _evaluateResponses.clear();
    notifyListeners();
  }

  double get averageScore {
    if (_evaluateResponses.isEmpty) return 0.0;

    for (var response in _evaluateResponses) {
      for (var result in response.results) {
        _totalScore += result.score.toInt();
        _scoreCount++;
      }
    }

    return _scoreCount > 0 ? _totalScore / _scoreCount : 0.0;
  }

  ApiResponse<EvaluateResponse> _evaluateResponse = ApiResponse.loading();
  ApiResponse<EvaluateResponse> get evaluateResponse => _evaluateResponse;

  Future<void> evaluateBE(
    Map<String, dynamic> formJson,
    String criteriaId,
    html.File file,
  ) async {
    _loadingIds.add(criteriaId);
    notifyListeners();

    final response = await backend.EvaluateService.submitEvaluation(
      formJson: formJson,
      criteriaId: criteriaId,
      file: file,
    );

    _loadingIds.remove(criteriaId);
    if (response.data != null) {
      _evaluateResponses.add(response.data!);
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
      percentage: percentage.toInt(),
      result: result,
    );

    await firebase.EvaluateService.addEvaluateRfi(
      projectName: title,
      location: 'N/A',
      budget: 0.0,
      rfiPdfBase64: fileUrl,
      evaluationResults: convertResponsesToRFIModels(_evaluateResponses),
      // _evaluateResponses.expand((e) => e.results).toList(),
    );
  }

  List<EvaluateRFIModel> convertResponsesToRFIModels(
    List<EvaluateResponse> responses,
  ) {
    return responses.asMap().entries.map((entry) {
      final index = entry.key;
      final response = entry.value;

      return EvaluateRFIModel(
        id: 'rfi_$index', // You can replace this with a UUID or Firebase doc ID
        projectName: 'Project $index', // Placeholder
        location: 'Unknown', // Placeholder
        budget: 0.0, // Placeholder
        rfiPdf: response.document,
        evaluationResults:
            response.results.isNotEmpty ? [response.results[0]] : [],
        archived: false, // Default value
      );
    }).toList();
  }

  Future<List<RFIModel>> fetchRFIs() async {
    try {
      final snapshot = await firebase.EvaluateService.evaluateAssessment.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id; // Use Firebase document ID as unique identifier
        return RFIModel(
          title: data['project_name'] as String? ?? 'Unknown Project',
          comment:
              (data['evaluation_results'] as List<dynamic>?)
                  ?.map(
                    (e) => (e as Map<String, dynamic>)['summary'] as String?,
                  )
                  .where((s) => s != null)
                  .join(', ') ??
              'AI evaluation summary',
          fileName:
              (data['rfi_pdf'] as String?)?.split('/').last ?? 'unknown.pdf',
          fileUrl: data['rfi_pdf'] as String? ?? '',
          percentage: _calculatePercentage(
            data['evaluation_results'] as List<dynamic>?,
          ),
          result: data['result'] as String? ?? 'PENDING', // Add result if saved
          id: id, // Store the document ID
        );
      }).toList();
    } catch (e) {
      console.log('Fetch RFIs error: $e');
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

  Future<void> deleteRFI(String documentId) async {
    await firebase.EvaluateService.evaluateAssessment.doc(documentId).delete();
  }

  Future<void> archiveRFI(String documentId) async {
    await firebase.EvaluateService.evaluateAssessment.doc(documentId).update({
      'archived': true,
    });
  }
}
