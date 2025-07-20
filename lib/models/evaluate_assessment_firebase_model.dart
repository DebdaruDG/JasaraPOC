class EvaluateResult {
  final String assistantId;
  final String criteria;
  final String summary;
  final double score;

  EvaluateResult({
    required this.assistantId,
    required this.criteria,
    required this.summary,
    required this.score,
  });

  factory EvaluateResult.fromMap(Map<String, dynamic> map) {
    return EvaluateResult(
      assistantId: map['assistant_id'],
      criteria: map['criteria'],
      summary: map['summary'],
      score: (map['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assistant_id': assistantId,
      'criteria': criteria,
      'summary': summary,
      'score': score,
    };
  }
}

class EvaluateRFIModel {
  final String id;
  final String projectName;
  final String location;
  final double budget;
  final String rfiPdf;
  final List<EvaluateResult> evaluationResults;

  EvaluateRFIModel({
    required this.id,
    required this.projectName,
    required this.location,
    required this.budget,
    required this.rfiPdf,
    required this.evaluationResults,
  });

  factory EvaluateRFIModel.fromDoc(String id, Map<String, dynamic> map) {
    return EvaluateRFIModel(
      id: id,
      projectName: map['project_name'],
      location: map['location'],
      budget: (map['budget'] as num).toDouble(),
      rfiPdf: map['rfi_pdf'],
      evaluationResults:
          List<Map<String, dynamic>>.from(
            map['evaluation_results'],
          ).map((e) => EvaluateResult.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project_name': projectName,
      'location': location,
      'budget': budget,
      'rfi_pdf': rfiPdf,
      'evaluation_results': evaluationResults.map((e) => e.toMap()).toList(),
    };
  }
}
