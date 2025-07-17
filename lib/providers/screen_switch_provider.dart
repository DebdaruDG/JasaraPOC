import 'package:flutter/material.dart';
import 'dart:html' as html;

class ScreenSwitchProvider extends ChangeNotifier {
  bool _showAssessment = false;
  html.File? _file;
  Map<String, dynamic>? _formJson;

  bool get showAssessment => _showAssessment;
  html.File? get file => _file;
  Map<String, dynamic>? get formJson => _formJson;

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
