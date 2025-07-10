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
}
