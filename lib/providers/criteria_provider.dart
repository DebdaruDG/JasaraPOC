import 'dart:developer' as console;
import 'dart:io';

import 'package:flutter/material.dart';
import '../core/services/api/api_response.dart';
import '../core/services/backend/criteria_services.dart';
import '../core/services/firebase/core_service.dart'; // <-- Add this
import '../models/evaluation_result.dart';
import '../models/response/criteria_response_model.dart';

class CriteriaProvider extends ChangeNotifier {
  final List<EvaluationResult> _results = [];

  List<EvaluationResult> get results => _results;

  void setCriteriaList(List<String> criteriaList) {
    _results.clear();
    for (var criteria in criteriaList) {
      _results.add(EvaluationResult(criteria: criteria));
    }
    notifyListeners();
  }

  void evaluateAll(String pdfBase64) {
    for (int i = 0; i < _results.length; i++) {
      // _evaluateSingle(i, pdfBase64);
    }
  }

  ApiResponse<CriteriaResponse> _responseBodyModel = ApiResponse.loading();
  ApiResponse<CriteriaResponse> get responseBodyModel => _responseBodyModel;

  /// ✅ Updated with FirebaseService logic
  Future<void> createCriteriaBE(
    String criteriaName,
    String textInstruction, {
    File? pdf1,
    File? pdf2,
    File? pdf3,
  }) async {
    _responseBodyModel = ApiResponse.loading();
    notifyListeners();

    final response = await CriteriaService.createCriteria(
      criteriaName: criteriaName,
      instruction: textInstruction,
    );

    if (response.status == Status.completed && response.data != null) {
      _responseBodyModel = ApiResponse.completed(response.data!);

      // ✅ Add to Firestore after backend returns assistantId
      final assistantId = response.data!.assistantId;
      await FirebaseService.addCriteriaPdf(
        assistantId: assistantId,
        title: criteriaName,
        textInstructions: textInstruction,
        pdf1: pdf1?.path,
        pdf2: pdf2?.path,
        pdf3: pdf3?.path,
      );
    } else {
      _responseBodyModel = ApiResponse.error(response.message);
    }

    notifyListeners();
  }
}
