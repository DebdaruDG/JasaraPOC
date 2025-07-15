import 'package:flutter/material.dart';

class RFIModel {
  final String title;
  final String comment;
  final String fileName;
  final String fileUrl;
  final int percentage;
  final String result; // 'GO' | 'NO GO' | 'REVIEW'

  RFIModel({
    required this.title,
    required this.comment,
    required this.fileName,
    required this.fileUrl,
    required this.percentage,
    required this.result,
  });

  Color get progressColor {
    if (result == 'GO') return Colors.teal;
    if (result == 'NO GO') return Colors.red;
    return Colors.amber;
  }

  String get resultLabel {
    if (result == 'GO') return 'GO';
    if (result == 'NO GO') return 'NO GO';
    return 'REVIEW';
  }
}
