import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'package:path/path.dart';

class FileUtils {
  static String getFileName(File file) => basename(file.path);

  static String formatFileSize(File file) {
    final bytes = file.lengthSync();
    final kb = bytes / 1024;
    return "${kb.toStringAsFixed(1)} KB";
  }

  static Future<String> fileToBase64(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<String>();

    reader.onLoad.listen((_) {
      final result = reader.result as String;
      final base64String = result.split(',').last;
      completer.complete(base64String);
    });

    reader.onError.listen((error) {
      completer.completeError('Failed to read file: $error');
    });
    reader.readAsDataUrl(file);
    return completer.future;
  }
}
