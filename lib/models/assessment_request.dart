class AssessmentRequest {
  final String assistantIds;
  final String rfpPdf;
  final String typeOfWork;
  final String? docId;

  AssessmentRequest({
    required this.assistantIds,
    required this.rfpPdf,
    required this.typeOfWork,
    this.docId,
  });

  factory AssessmentRequest.fromMap(Map<String, dynamic> map, [String? id]) {
    return AssessmentRequest(
      assistantIds: map['assistant_ids'] ?? '',
      rfpPdf: map['rfp_pdf'] ?? '',
      typeOfWork: map['type_of_work'] ?? '',
      docId: id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assistant_ids': assistantIds,
      'rfp_pdf': rfpPdf,
      'type_of_work': typeOfWork,
    };
  }
}
