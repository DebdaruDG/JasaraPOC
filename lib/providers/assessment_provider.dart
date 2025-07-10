import 'package:flutter/foundation.dart';
import '../core/services/api/api_client.dart';
import '../core/services/api/api_response.dart';
import '../models/assessment_result.dart';

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
}
