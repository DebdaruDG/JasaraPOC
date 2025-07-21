class CriteriaModel {
  final String assistantId;
  final String textInstructions;
  final String title;
  final String? docId; // optional Firestore doc ID
  final List<CriteriaFileModel> files;

  CriteriaModel({
    required this.assistantId,
    required this.textInstructions,
    required this.title,
    this.docId,
    required this.files,
  });

  factory CriteriaModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return CriteriaModel(
      assistantId: map['assistant_id'] ?? '',
      textInstructions: map['text_instructions'] ?? '',
      title: map['title'] ?? '',
      docId: id,
      files:
          (map['files'] as List<dynamic>?)
              ?.map(
                (e) => CriteriaFileModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assistant_id': assistantId,
      'text_instructions': textInstructions,
      'title': title,
      'files': files.map((e) => e.toJson()).toList(),
    };
  }

  factory CriteriaModel.fromDoc(String id, Map<String, dynamic> data) {
    return CriteriaModel(
      docId: id,
      assistantId: data['assistant_id'] ?? '',
      title: data['title'] ?? '',
      textInstructions: data['text_instructions'] ?? '',
      files:
          (data['files'] as List<dynamic>?)
              ?.map(
                (e) => CriteriaFileModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
    );
  }
}

class CriteriaFileModel {
  final String name;
  final String base64;

  CriteriaFileModel({required this.name, required this.base64});

  Map<String, dynamic> toJson() => {'name': name, 'base64': base64};

  factory CriteriaFileModel.fromJson(Map<String, dynamic> json) {
    return CriteriaFileModel(name: json['name'], base64: json['base64']);
  }
}
