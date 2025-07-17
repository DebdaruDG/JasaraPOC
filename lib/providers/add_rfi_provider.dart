import 'dart:io';
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

  html.File? _uploadedFileHtml;
  File? _uploadedFile;
  String? _uploadedFileName;
  bool _isDragOver = false;

  Map<String, TextEditingController> get controllers => _controllers;
  File? get uploadedFile => _uploadedFile;
  html.File? get uploadedFileHtml => _uploadedFileHtml;
  String? get uploadedFileName => _uploadedFileName;
  bool get isDragOver => _isDragOver;

  void setFinalDecision(String? value) {
    // Preserved for compatibility, though unused in current context
    notifyListeners();
  }

  void setUploadedFile(html.File? fileHtml, File? fileIo, [String? fileName]) {
    _uploadedFileHtml = fileHtml;
    _uploadedFile = fileIo;
    _uploadedFileName = fileName;
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
