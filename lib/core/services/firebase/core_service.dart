import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/criteria_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection 1: criteria_pdfs
  static CollectionReference get criteriaPdfs =>
      _firestore.collection('criteria_pdfs');

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
    String? pdf1,
    String? pdf2,
    String? pdf3,
  }) async {
    try {
      final result = await criteriaPdfs.add({
        'assistant_id': assistantId,
        'pdf1': pdf1,
        'pdf2': pdf2,
        'pdf3': pdf3,
        'text_instructions': textInstructions,
        'title': title,
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

  // Optional: Get all documents
  static Stream<QuerySnapshot> getCriteriaStream() {
    return criteriaPdfs.snapshots();
  }

  static Stream<QuerySnapshot> getFrpPdfStream() {
    return frpPdf.snapshots();
  }
}
