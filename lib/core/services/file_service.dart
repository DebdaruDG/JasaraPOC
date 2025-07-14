import 'dart:async';
import 'dart:html' as html;
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  static Future<dynamic> pickPDF({int maxSizeKB = 500}) async {
    if (kIsWeb) {
      final uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.pdf';
      uploadInput.click();

      final completer = Completer<html.File?>();
      uploadInput.onChange.listen((e) {
        final file = uploadInput.files?.first;
        completer.complete(file);
      });

      return completer.future;
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        return io.File(result.files.single.path!);
      }
      return null;
    }
  }

  static int getFileSizeInKB(io.File file) => file.lengthSync() ~/ 1024;

  static Future<dynamic> handleDroppedFiles(List<dynamic> droppedFiles) async {
    if (kIsWeb) {
      if (droppedFiles.isNotEmpty && droppedFiles.first is html.File) {
        return droppedFiles.first;
      }
      return null;
    } else {
      for (var file in droppedFiles) {
        if (file is PlatformFile &&
            file.extension?.toLowerCase() == 'pdf' &&
            file.path != null) {
          return io.File(file.path!);
        } else if (file is String && file.toLowerCase().endsWith('.pdf')) {
          return io.File(file);
        }
      }
      return null;
    }
  }
}
