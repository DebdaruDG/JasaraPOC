class CriteriaSummaryResponseModel {
  final String summary;

  CriteriaSummaryResponseModel({required this.summary});

  factory CriteriaSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return CriteriaSummaryResponseModel(summary: json['summary'] ?? '');
  }
}
