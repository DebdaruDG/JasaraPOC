import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileService {
  static Future<File?> pickPDF({int maxSizeKB = 500}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.size <= maxSizeKB * 1024) {
      return File(result.files.single.path!);
    }
    return null;
  }

  static int getFileSizeInKB(File file) => file.lengthSync() ~/ 1024;

  static Future<File?> handleDroppedFiles(List<dynamic> droppedFiles) async {
    if (droppedFiles.isEmpty) return null;

    for (var file in droppedFiles) {
      if (file is PlatformFile) {
        if (file.extension?.toLowerCase() == 'pdf' && file.path != null) {
          return File(file.path!);
        }
      } else if (file is String) {
        if (file.toLowerCase().endsWith('.pdf')) {
          return File(file);
        }
      }
    }
    return null;
  }
}
