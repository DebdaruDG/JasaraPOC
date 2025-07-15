import 'package:flutter/material.dart';
import 'dart:html' as html;

class HomePageProvider extends ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {
    'opportunityCode': TextEditingController(),
    'opportunityName': TextEditingController(),
    'date': TextEditingController(),
    'proposalManager': TextEditingController(),
    'description': TextEditingController(),
    'projectType': TextEditingController(),
    'clientName': TextEditingController(),
    'clientType': TextEditingController(),
    'relationship': TextEditingController(),
    'submissionDate': TextEditingController(),
    'biddingCriteria': TextEditingController(),
    'isTargeted': TextEditingController(),
    'comments': TextEditingController(),
    'project_name': TextEditingController(),
    'budget': TextEditingController(),
    'location': TextEditingController(),
  };

  String? _finalDecision;
  html.File? _uploadedFile;
  bool _isDragOver = false;

  Map<String, TextEditingController> get controllers => _controllers;
  String? get finalDecision => _finalDecision;
  html.File? get uploadedFile => _uploadedFile;
  bool get isDragOver => _isDragOver;

  void setFinalDecision(String? value) {
    _finalDecision = value;
    notifyListeners();
  }

  Future<void> setUploadedFile(html.File? file) async {
    _uploadedFile = file;
    notifyListeners();
  }

  void setDragOver(bool value) {
    _isDragOver = value;
    notifyListeners();
  }

  void disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
  }
}
