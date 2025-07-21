import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/criteria_model.dart';
import '../../../models/evaluate_assessment_firebase_model.dart';
import 'firebase_collections.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection 1: criteria_pdfs
  static CollectionReference get criteriaPdfs =>
      _firestore.collection(FirebaseCollectionNames.criteriaPDFs);

  // This list will hold fetched criteria

  static Future<List<CriteriaModel>> fetchCriteriaList() async {
    List<CriteriaModel> criteriaList = [];
    try {
      final snapshot = await criteriaPdfs.get();
      criteriaList =
          snapshot.docs.map((doc) {
            return CriteriaModel.fromDoc(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
      console.log('Loaded ${criteriaList.length} criteria from Firestore.');
      return criteriaList;
    } catch (e) {
      console.log('Error loading criteria list: $e');
      return [];
    }
  }

  // Add a new criteria
  static Future<void> addCriteriaPdf({
    required String assistantId,
    required String textInstructions,
    required String title,
    required List<CriteriaFileModel> files,
  }) async {
    try {
      final result = await criteriaPdfs.add({
        'assistant_id': assistantId,
        'text_instructions': textInstructions,
        'title': title,
        'files': files.map((f) => f.toJson()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      console.log('Criteria added to Firestore: $result');
    } on FirebaseException catch (e) {
      console.log('FirebaseException: ${e.message}');
    } catch (e) {
      console.log('Error adding criteria PDF: $e');
    }
  }

  // Collection 2: rfp_pdf
  static CollectionReference get frpPdf => _firestore.collection('rfp_pdf');

  // Add a new frp document
  static Future<void> addRfpPDF({
    required String assistantIds,
    required String rfpPdf,
    required String typeOfWork,
  }) async {
    await frpPdf.add({
      'assistant_ids': assistantIds,
      'rfp_pdf': rfpPdf,
      'type_of_work': typeOfWork,
    });
  }

  static CollectionReference get evaluateAssessment =>
      _firestore.collection(FirebaseCollectionNames.evaluateAssessment);

  // Add a new document to Evaluate_Assessment_Collection
  static Future<void> addEvaluateAssessment({
    required String projectName,
    required String location,
    required double budget,
    required String rfiPdfBase64,
    required List<EvaluateResult> evaluationResults,
  }) async {
    try {
      final payload = {
        'project_name': projectName,
        'location': location,
        'budget': budget,
        'rfi_pdf': rfiPdfBase64,
        'evaluation_results': evaluationResults.map((e) => e.toMap()).toList(),
      };
      await evaluateAssessment.add(payload);
      console.log('Added evaluation assessment successfully.');
    } catch (e) {
      console.log('Error adding evaluation assessment: $e');
    }
  }

  // Fetch all documents from Evaluate_Assessment_Collection
  static Future<List<EvaluateRFIModel>> fetchEvaluateAssessments() async {
    try {
      final snapshot = await evaluateAssessment.get();
      return snapshot.docs.map((doc) {
        return EvaluateRFIModel.fromDoc(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      console.log('Error fetching assessments: $e');
      return [];
    }
  }

  static Future<void> deleteCriteria(String documentId) async {
    try {
      await criteriaPdfs.doc(documentId).delete();
      console.log('Criteria with ID $documentId deleted successfully.');
    } catch (e) {
      console.log('Error deleting criteria: $e');
    }
  }

  // Optional: Get all documents
  static Stream<QuerySnapshot> getCriteriaStream() {
    return criteriaPdfs.snapshots();
  }

  static Stream<QuerySnapshot> getFrpPdfStream() {
    return frpPdf.snapshots();
  }
}
