import 'dart:convert';
import 'package:flutter/services.dart';

class JsonLoader {
  static Future<Map<String, dynamic>> loadMockResult() async {
    final data = await rootBundle.loadString('assets/data/dummy_result.json');
    return json.decode(data);
  }
}
