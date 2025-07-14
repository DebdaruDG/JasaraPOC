import 'dart:convert';
import 'dart:developer' as console;
import '../../../models/response/evaluate_response_model.dart';
import '../../constants/api_urls.dart';
import '../api/api_base_service.dart';
import '../api/api_response.dart';

import 'dart:html' as html;

class EvaluateService {
  static Future<ApiResponse<EvaluateResponse>> submitEvaluation({
    required Map<String, dynamic> formJson,
    required String criteriaId,
    required html.File file,
  }) async {
    try {
      final response = await ApiBaseService(
        URLconstants.baseUrlRender,
      ).postMultipart<EvaluateResponse>(
        'evaluate',
        fields: {'form_json': jsonEncode(formJson), 'criteria_ids': criteriaId},
        file: file,
        fileName: 'RFI_HR_Solutions.pdf',
        fromJson: (json) => EvaluateResponse.fromJson(json),
      );
      console.log('response - $response');
      return ApiResponse.completed(response.data!);
    } catch (e) {
      console.log('Error submitting evaluation: $e');
      return ApiResponse.error('Error submitting evaluation: $e');
    }
  }
}
