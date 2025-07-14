import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import '../core/services/api/api_client.dart';
import '../core/services/api/api_response.dart';
import '../core/services/backend/evaluate_service.dart';
import '../models/assessment_result.dart';
import '../models/response/evaluate_response_model.dart';

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

  clearEvaluateResponses() {
    _evaluateResponses.clear();
    notifyListeners();
  }

  double get averageScore {
    if (_evaluateResponses.isEmpty) return 0.0;

    int totalScore = 0;
    int scoreCount = 0;

    for (var response in _evaluateResponses) {
      for (var result in response.results) {
        totalScore += result.score;
        scoreCount++;
      }
    }

    return scoreCount > 0 ? totalScore / scoreCount : 0.0;
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

    final response = await EvaluateService.submitEvaluation(
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
}
