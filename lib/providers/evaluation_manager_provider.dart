import 'dart:io';

import 'package:flutter/material.dart';

import '../core/services/api/api_response.dart';
import '../core/services/backend/evaluate_service.dart';
import '../models/criteria_model.dart';
import '../models/response/evaluate_response_model.dart';

class EvaluationManagerProvider with ChangeNotifier {
  final Map<String, ApiResponse<EvaluateResponse>> _evaluations = {};

  Map<String, ApiResponse<EvaluateResponse>> get evaluations => _evaluations;

  Future<void> evaluateSingleCriteria({
    required CriteriaModel criteria,
    required Map<String, dynamic> formJson,
    required File file,
  }) async {
    final criteriaId = criteria.docId!;
    _evaluations[criteriaId] = ApiResponse.loading();
    notifyListeners();

    try {
      final response = await EvaluateService.submitEvaluation(
        formJson: formJson,
        criteriaId: criteriaId,
        file: file,
      );

      _evaluations[criteriaId] = response;
    } catch (e) {
      _evaluations[criteriaId] = ApiResponse.error('Error: $e');
    }

    notifyListeners();
  }

  void resetAll() {
    _evaluations.clear();
    notifyListeners();
  }
}
