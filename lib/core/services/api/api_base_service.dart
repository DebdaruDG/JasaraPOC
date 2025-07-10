import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_response.dart';
import 'network_exceptions.dart';

class ApiBaseService {
  final String baseUrl;

  ApiBaseService(this.baseUrl);

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(res, fromJson);
    } catch (e) {
      return ApiResponse.error(NetworkExceptions.getMessage(e));
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json', ...?headers},
        body: jsonEncode(body),
      );
      return _handleResponse(res, fromJson);
    } catch (e) {
      return ApiResponse.error(NetworkExceptions.getMessage(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response res,
    T Function(dynamic json) fromJson,
  ) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      return ApiResponse.completed(fromJson(data));
    } else {
      return ApiResponse.error('Error ${res.statusCode}: ${res.reasonPhrase}');
    }
  }
}
