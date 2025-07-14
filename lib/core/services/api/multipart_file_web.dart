// lib/services/api/helpers/multipart_file_web.dart

import 'dart:html' as html;

dynamic getPlatformFile(dynamic file) {
  return file as html.File;
}
