import 'dart:convert';
import 'dart:developer' as console;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/services/api/api_response.dart';
import '../core/services/backend/criteria_services.dart';
import '../core/services/firebase/core_service.dart';
import '../models/criteria_model.dart';
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

  ApiResponse<CriteriaResponse> _responseBodyModel = ApiResponse.loading();
  ApiResponse<CriteriaResponse> get responseBodyModel => _responseBodyModel;

  Future<String?> platformFileToBase64(PlatformFile? file) async {
    if (file == null) return null;
    try {
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      console.log('Error converting PlatformFile to base64: $e');
      return null;
    }
  }

  /// ✅ Updated with FirebaseService logic
  Future<void> createCriteriaBE(
    String criteriaName,
    String textInstruction, {
    PlatformFile? pdf1,
    PlatformFile? pdf2,
    PlatformFile? pdf3,
  }) async {
    _responseBodyModel = ApiResponse.loading();
    notifyListeners();

    // ✅ Filter out null PDFs
    final validPdfs = [pdf1, pdf2, pdf3].whereType<PlatformFile>().toList();

    final response = await CriteriaService.createCriteria(
      criteriaName: criteriaName,
      instruction: textInstruction,
      pdfFiles: validPdfs,
    );

    console.log('response.status - ${response.status}');

    console.log('response.data :- ${response.data}');
    if (response.status == Status.completed && response.data != null) {
      _responseBodyModel = ApiResponse.completed(response.data!);

      final assistantId = response.data!.assistantId;
      List<CriteriaFileModel> criteriaFiles = [];
      for (PlatformFile pdf in validPdfs) {
        String? base64 = await platformFileToBase64(pdf);
        if (base64 != null) {
          criteriaFiles.add(CriteriaFileModel(name: pdf.name, base64: base64));
        }
      }

      await FirebaseService.addCriteriaPdf(
        assistantId: assistantId,
        title: criteriaName,
        textInstructions: textInstruction,
        files: criteriaFiles,
      );
      await fetchCriteriaList();
    } else {
      _responseBodyModel = ApiResponse.error(response.message);
    }

    notifyListeners();
  }

  final List<CriteriaModel> _criteriaListResponse = [];
  List<CriteriaModel> get criteriaListResponse => _criteriaListResponse;

  Future<void> fetchCriteriaList() async {
    final response = await FirebaseService.fetchCriteriaList();
    if (response.isNotEmpty) {
      _criteriaListResponse.clear();
      _criteriaListResponse.addAll(response);
    } else {
      debugPrint('No criteria found');
    }
    notifyListeners();
  }
}
