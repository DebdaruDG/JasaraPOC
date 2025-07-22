import 'dart:convert';
import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/evaluate_assessment_firebase_model.dart';
import 'firebase_collections.dart';

class EvaluateService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference get evaluateAssessment =>
      _firestore.collection(FirebaseCollectionNames.evaluateAssessment);

  // Add a new evaluate RFI PDF
  static Future<void> addEvaluateRfi({
    required String projectName,
    required String location,
    required String summarizerComment,
    required double budget,
    required double evaluationPercentage,
    required String rfiPdfBase64,
    required String fileName,
    required List<EvaluateRFIModel> evaluationResults,
  }) async {
    try {
      final payload = {
        'project_name': projectName,
        'summarizerComment': summarizerComment,
        'evaluationPercentage': evaluationPercentage,
        'location': location,
        'budget': budget,
        'rfi_pdf': rfiPdfBase64,
        'fileName': fileName,
        'evaluation_results': evaluationResults.map((e) => e.toMap()).toList(),
        'archived': false,
      };
      console.log('payload - ${jsonEncode(payload)}');
      await evaluateAssessment.add(payload);
      console.log('Added evaluate RFI successfully.');
    } catch (e) {
      console.log('Error adding evaluate RFI: $e');
    }
  }

  // Update an existing evaluate RFI PDF
  static Future<void> updateEvaluateRfi({
    required String documentId,
    String? projectName,
    String? location,
    double? budget,
    String? rfiPdfBase64,
    List<EvaluateRFIModel>? evaluationResults,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (projectName != null) data['project_name'] = projectName;
      if (location != null) data['location'] = location;
      if (budget != null) data['budget'] = budget;
      if (rfiPdfBase64 != null) data['rfi_pdf'] = rfiPdfBase64;
      if (evaluationResults != null) {
        data['evaluation_results'] =
            evaluationResults.map((e) => e.toMap()).toList();
      }
      await evaluateAssessment.doc(documentId).update(data);
      console.log('Updated evaluate RFI with ID $documentId successfully.');
    } catch (e) {
      console.log('Error updating evaluate RFI: $e');
    }
  }

  // Delete an evaluate RFI PDF
  static Future<void> deleteEvaluateRfi(String documentId) async {
    try {
      await evaluateAssessment.doc(documentId).delete();
    } catch (e) {
      console.log('Error deleting evaluate RFI: $e');
    }
  }

  // Archive an evaluate RFI PDF
  static Future<void> archiveEvaluateRfi(String documentId) async {
    try {
      await evaluateAssessment.doc(documentId).update({'archived': true});
      console.log('Archived evaluate RFI with ID $documentId successfully.');
    } catch (e) {
      console.log('Error archiving evaluate RFI: $e');
    }
  }
}
