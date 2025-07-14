import 'dart:developer' as console;
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

  ApiResponse<EvaluateResponse> _evaluateResponse = ApiResponse.loading();
  ApiResponse<EvaluateResponse> get evaluateResponse => _evaluateResponse;

  Future<void> evaluateBE(
    Map<String, dynamic> formJson,
    String criteriaId,
    html.File file,
  ) async {
    _evaluateResponse = ApiResponse.loading();
    notifyListeners();

    final response = await EvaluateService.submitEvaluation(
      formJson: formJson,
      criteriaId: criteriaId,
      file: file,
    );
    console.log('Evaluation Response: ${response.data}');
    _evaluateResponse = response;
    notifyListeners();
  }

  Future<void> reset() async {
    _result = ApiResponse.loading();
    _evaluateResponse = ApiResponse.loading();
    notifyListeners();
  }
}
