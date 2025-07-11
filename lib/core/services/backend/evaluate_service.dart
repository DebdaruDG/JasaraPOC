import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../models/response/evaluate_response_model.dart';
import '../../constants/api_urls.dart';
import '../api/api_response.dart';
import '../api/network_exceptions.dart';

class EvaluateService {
  static Future<ApiResponse<EvaluateResponse>> submitEvaluation({
    required Map<String, dynamic> formJson,
    required String criteriaId,
    required File file,
  }) async {
    try {
      final uri = Uri.parse('${URLconstants.baseUrlRender}evaluate');

      var request =
          http.MultipartRequest('POST', uri)
            ..fields['form_json'] = jsonEncode(formJson)
            ..fields['criteria_ids'] = criteriaId
            ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.completed(EvaluateResponse.fromJson(data));
      } else {
        return ApiResponse.error(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return ApiResponse.error(NetworkExceptions.getMessage(e));
    }
  }
}
