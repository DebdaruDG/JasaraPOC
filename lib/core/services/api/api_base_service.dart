import 'dart:async';
import 'dart:convert';
import 'dart:developer' as console;
import 'dart:html' as html;
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

  /// 💡 Multipart POST - Web Only
  Future<ApiResponse<T>> postMultipart<T>(
    String endpoint, {
    required Map<String, dynamic> fields,
    required html.File file,
    required T Function(dynamic json) fromJson,
    String fileFieldName = 'file',
    String fileName = 'upload.pdf',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final formData = html.FormData();
      fields.forEach((key, value) {
        formData.append(key, value.toString());
      });

      formData.appendBlob(fileFieldName, file, fileName);

      console.log('formdata - ${formData.toString()}');

      final completer = Completer<ApiResponse<T>>();
      final request = html.HttpRequest();

      request
        ..open('POST', uri.toString())
        ..onLoadEnd.listen((event) {
          console.log("Response Status: ${request.status}");
          if (!completer.isCompleted) {
            if (request.status == 200) {
              try {
                final data = jsonDecode(request.responseText!);
                console.log('Response Data: $data');
                completer.complete(ApiResponse.completed(fromJson(data)));
              } catch (e) {
                completer.complete(ApiResponse.error('Invalid JSON Response'));
              }
            } else {
              completer.complete(
                ApiResponse.error(
                  'Error ${request.status}: ${request.statusText}',
                ),
              );
            }
          }
        })
        ..onError.listen((event) {
          console.log('Error occurred: ${event.toString()}');
          if (!completer.isCompleted) {
            completer.complete(ApiResponse.error('Network error occurred'));
          }
        })
        ..send(formData);

      return completer.future;
    } catch (e) {
      console.log('Error in postMultipart: $e');
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
