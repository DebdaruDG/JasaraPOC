import '../evaluate_assessment_firebase_model.dart';

class EvaluateResponse {
  final String document;
  final List<EvaluateResult> results;

  EvaluateResponse({required this.document, required this.results});

  factory EvaluateResponse.fromJson(Map<String, dynamic> json) {
    return EvaluateResponse(
      document: json['document'] as String,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((x) => EvaluateResult.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'results': results.map((x) => x.toMap()).toList(),
    };
  }
}
