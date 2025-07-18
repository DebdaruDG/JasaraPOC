import 'dart:convert';
import 'dart:developer' as console;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../../models/response/criteria_response_model.dart';
import '../../constants/api_urls.dart';
import '../api/api_response.dart';
import '../api/network_exceptions.dart';
import 'package:http_parser/http_parser.dart';

class CriteriaService {
  static Future<ApiResponse<CriteriaResponse>> createCriteria({
    required String criteriaName,
    required String instruction,
    required List<PlatformFile> pdfFiles,
  }) async {
    try {
      final uri = Uri.parse('${URLconstants.baseUrlRender}criteria');

      var request =
          http.MultipartRequest('POST', uri)
            ..fields['criteria_name'] = criteriaName
            ..fields['criteria_instruction'] = instruction
            ..headers['pdf'] = 'application/pdf';

      if (pdfFiles.isNotEmpty) {
        for (PlatformFile file in pdfFiles) {
          request.files.add(
            await http.MultipartFile.fromBytes(
              'file',
              file.bytes!,
              filename: file.name,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      console.log('response status code - ${response.statusCode}');
      console.log('response.body - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.completed(CriteriaResponse.fromJson(data));
      } else {
        return ApiResponse.error(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      console.log('Error in createCriteria: $e');
      return ApiResponse.error(NetworkExceptions.getMessage(e));
    }
  }
}
