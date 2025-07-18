import 'package:flutter/material.dart';

import '../widgets/utils/app_palette.dart';

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
    if (result == 'GO') return JasaraPalette.go;
    if (result == 'NO GO') return JasaraPalette.noGo;
    return JasaraPalette.review;
  }

  String get resultLabel {
    if (result == 'GO') return 'GO';
    if (result == 'NO GO') return 'NO GO';
    return 'REVIEW';
  }
}
