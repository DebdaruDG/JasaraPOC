// lib/services/api/helpers/multipart_file_io.dart

import 'dart:io' as io;

dynamic getPlatformFile(dynamic file) {
  return file as io.File;
}
