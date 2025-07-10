class AssessmentResult {
  final List<AssessmentCriteria> criteriaList;
  final double finalScore;

  AssessmentResult({required this.criteriaList, required this.finalScore});

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    final criteria =
        (json['criteria'] as List<dynamic>).map((e) {
          return AssessmentCriteria.fromJson(e);
        }).toList();

    return AssessmentResult(
      criteriaList: criteria,
      finalScore: (json['final_score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'criteria': criteriaList.map((e) => e.toJson()).toList(),
      'final_score': finalScore,
    };
  }

  static AssessmentResult mock() {
    return AssessmentResult(
      finalScore: 8.3,
      criteriaList: [
        AssessmentCriteria(
          title: 'Clarity',
          response: 'The RFP was clearly articulated and aligns with goals.',
          score: 9.0,
        ),
        AssessmentCriteria(
          title: 'Feasibility',
          response: 'Moderate feasibility due to tight deadlines.',
          score: 7.5,
        ),
        AssessmentCriteria(
          title: 'Relevance',
          response: 'Strong alignment with core competencies.',
          score: 8.5,
        ),
      ],
    );
  }
}

class AssessmentCriteria {
  final String title;
  final String response;
  final double score;

  AssessmentCriteria({
    required this.title,
    required this.response,
    required this.score,
  });

  factory AssessmentCriteria.fromJson(Map<String, dynamic> json) {
    return AssessmentCriteria(
      title: json['title'] ?? '',
      response: json['response'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'response': response, 'score': score};
  }
}
