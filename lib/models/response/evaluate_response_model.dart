class EvaluateResponse {
  final String document;
  final List<EvaluateResult> results;

  EvaluateResponse({required this.document, required this.results});

  factory EvaluateResponse.fromJson(Map<String, dynamic> json) {
    return EvaluateResponse(
      document: json['document'],
      results: List<EvaluateResult>.from(
        json['results'].map((x) => EvaluateResult.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'results': results.map((x) => x.toJson()).toList(),
    };
  }
}

class EvaluateResult {
  final String assistantId;
  final String criteria;
  final String summary;
  final int score;

  EvaluateResult({
    required this.assistantId,
    required this.criteria,
    required this.summary,
    required this.score,
  });

  factory EvaluateResult.fromJson(Map<String, dynamic> json) {
    return EvaluateResult(
      assistantId: json['assistant_id'],
      criteria: json['criteria'],
      summary: json['summary'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant_id': assistantId,
      'criteria': criteria,
      'summary': summary,
      'score': score,
    };
  }
}
