class CriteriaModel {
  final String assistantId;
  final String pdf1;
  final String pdf2;
  final String pdf3;
  final String textInstructions;
  final String title;
  final String? docId; // optional Firestore doc ID

  CriteriaModel({
    required this.assistantId,
    required this.pdf1,
    required this.pdf2,
    required this.pdf3,
    required this.textInstructions,
    required this.title,
    this.docId,
  });

  factory CriteriaModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return CriteriaModel(
      assistantId: map['assistant_id'] ?? '',
      pdf1: map['pdf1'] ?? '',
      pdf2: map['pdf2'] ?? '',
      pdf3: map['pdf3'] ?? '',
      textInstructions: map['text_instructions'] ?? '',
      title: map['title'] ?? '',
      docId: id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assistant_id': assistantId,
      'pdf1': pdf1,
      'pdf2': pdf2,
      'pdf3': pdf3,
      'text_instructions': textInstructions,
      'title': title,
    };
  }
}
