import 'dart:io';
import 'package:path/path.dart';

class FileUtils {
  static String getFileName(File file) => basename(file.path);

  static String formatFileSize(File file) {
    final bytes = file.lengthSync();
    final kb = bytes / 1024;
    return "${kb.toStringAsFixed(1)} KB";
  }
}
