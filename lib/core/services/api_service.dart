import 'dart:html' as html;

class ApiService {
  static Future<Map<String, dynamic>> submitAssessment({
    required html.File rfp,
    required html.File goNoGo,
  }) async {
    await Future.delayed(Duration(seconds: 2)); // simulate API delay
    return {
      'criteria': ['Clarity', 'Relevance'],
      'responses': ['Good fit', 'Lacks detail'],
      'score': 7.5,
    };
  }

  static Future<bool> saveConfiguration(
    List<Map<String, dynamic>> config,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
