import 'package:flutter/material.dart';

import '../widgets/utils/app_palette.dart';

class RFIModel {
  final String id;
  final String title;
  final String comment;
  final String fileName;
  final String fileUrl;
  final String result; // 'GO' | 'NO GO' | 'REVIEW'
  final String summarizerComment;
  final double percentage;

  RFIModel({
    required this.id,
    required this.title,
    required this.comment,
    required this.fileName,
    required this.fileUrl,
    required this.percentage,
    required this.result,
    required this.summarizerComment,
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
