class CriteriaSummaryRequestModel {
  final List<String> criteriaDescriptions;

  CriteriaSummaryRequestModel({required this.criteriaDescriptions});

  Map<String, dynamic> toJson() => {
    'criteriaDescriptions': criteriaDescriptions,
  };
}
