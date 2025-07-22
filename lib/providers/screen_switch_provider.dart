import 'package:flutter/material.dart';
import 'dart:html' as html;

class ScreenSwitchProvider extends ChangeNotifier {
  bool _showAssessment = false;
  bool get showAssessment => _showAssessment;

  html.File? _file;
  html.File? get file => _file;
  setFile(html.File? val) {
    _file = val;
    notifyListeners();
  }

  Map<String, dynamic>? _formJson;
  Map<String, dynamic>? get formJson => _formJson;
  setFormJson(Map<String, dynamic> val) {
    _formJson = val;
    notifyListeners();
  }

  void toggleAssessment(
    bool value, {
    html.File? file,
    Map<String, dynamic>? formJson,
  }) {
    _showAssessment = value;
    _file = file;
    _formJson = formJson;
    notifyListeners(); // Ensure this is called to trigger rebuild
  }
}
