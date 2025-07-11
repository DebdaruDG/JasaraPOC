import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../models/response/criteria_response_model.dart';
import '../../constants/api_urls.dart';
import '../api/api_response.dart';
import '../api/network_exceptions.dart';

class CriteriaService {
  static Future<ApiResponse<CriteriaResponse>> createCriteria({
    required String criteriaName,
    required String instruction,
    File? pdfFile, // Uncomment if you want to handle file uploads
  }) async {
    try {
      final uri = Uri.parse('${URLconstants.baseUrlRender}criteria');

      var request =
          http.MultipartRequest('POST', uri)
            ..fields['criteria_name'] = criteriaName
            ..fields['criteria_instruction'] = instruction
            ..headers['pdf'] = 'application/pdf';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.completed(CriteriaResponse.fromJson(data));
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
