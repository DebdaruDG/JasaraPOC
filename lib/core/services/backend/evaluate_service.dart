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
      return ApiResponse.completed(EvaluateResponse(document: '', results: []));
    } catch (e) {
      console.log('Error submitting evaluation: $e');
      return ApiResponse.error('Error submitting evaluation: $e');
    }
    // try {
    //   final uri = Uri.parse('${URLconstants.baseUrlRender}evaluate');

    //   if (kIsWeb) {
    //     final html.FormData formData = html.FormData();
    //     formData.append('form_json', jsonEncode(formJson));
    //     formData.append('criteria_ids', criteriaId);
    //     formData.appendBlob('file', file, 'RFI_HR_Solutions.pdf');

    //     final request = html.HttpRequest();
    //     request
    //       ..open('POST', uri.toString())
    //       ..onLoadEnd.listen((_) {
    //         console.log("Response Status: ${request.status}");
    //       })
    //       ..send(formData);

    //     return ApiResponse.loading();
    //   } else {
    //     // Mobile/Desktop logic
    //     final io.File ioFile = file as io.File;
    //     var request =
    //         http.MultipartRequest('POST', uri)
    //           ..fields['form_json'] = jsonEncode(formJson)
    //           ..fields['criteria_ids'] = criteriaId
    //           ..files.add(
    //             await http.MultipartFile.fromPath('file', ioFile.path),
    //           );

    //     final streamedResponse = await request.send();
    //     final response = await http.Response.fromStream(streamedResponse);

    //     if (response.statusCode == 200) {
    //       final data = jsonDecode(response.body);
    //       return ApiResponse.completed(EvaluateResponse.fromJson(data));
    //     } else {
    //       return ApiResponse.error(
    //         'Error ${response.statusCode}: ${response.reasonPhrase}',
    //       );
    //     }
    //   }
    // } catch (e) {
    //   console.log('Error in EvaluateService: $e');
    //   return ApiResponse.error(NetworkExceptions.getMessage(e));
    // }
  }
}
