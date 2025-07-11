import '../core/services/api/api_response.dart';

class EvaluationResult {
  final String criteria;
  Status status;
  String? result;

  EvaluationResult({
    required this.criteria,
    this.status = Status.loading,
    this.result,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      criteria: json['criteria'],
      status: _statusFromString(json['status']),
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'criteria': criteria, 'status': status.name, 'result': result};
  }

  static Status _statusFromString(String? status) {
    switch (status) {
      case 'completed':
        return Status.completed;
      case 'error':
        return Status.error;
      case 'loading':
      default:
        return Status.loading;
    }
  }
}
