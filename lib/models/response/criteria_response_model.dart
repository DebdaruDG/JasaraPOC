class CriteriaResponse {
  final String assistantId;
  final String criteria;
  final String instruction;
  final List<dynamic> fileIds;

  CriteriaResponse({
    required this.assistantId,
    required this.criteria,
    required this.instruction,
    required this.fileIds,
  });

  factory CriteriaResponse.fromJson(Map<String, dynamic> json) {
    return CriteriaResponse(
      assistantId: json['assistant_id'],
      criteria: json['criteria'],
      instruction: json['instruction'],
      fileIds: json['file_ids'] ?? [],
    );
  }
}
