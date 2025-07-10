import '../../../models/assessment_result.dart';
import 'api_base_service.dart';
import 'api_response.dart';

class ApiClient {
  final _service = ApiBaseService('https://api.yourdomain.com');

  Future<ApiResponse<AssessmentResult>> submitAssessment(
    Map<String, dynamic> body,
  ) {
    return _service.post<AssessmentResult>(
      '/assess',
      body: body,
      fromJson: (json) => AssessmentResult.fromJson(json),
    );
  }

  Future<ApiResponse<List<AssessmentResult>>> getAllAssessments() {
    return _service.get<List<AssessmentResult>>(
      '/assessments',
      fromJson:
          (json) =>
              (json as List).map((e) => AssessmentResult.fromJson(e)).toList(),
    );
  }
}
