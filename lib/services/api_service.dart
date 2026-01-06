import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ApiResponse {
  final int statusCode;
  final String body;

  const ApiResponse({required this.statusCode, required this.body});

  bool get ok => statusCode >= 200 && statusCode < 300;
}

class ApiService {
  // Example GET request
  Future<ApiResponse?> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return ApiResponse(statusCode: response.statusCode, body: response.body);
    } catch (e) {
      developer.log('GET error', name: 'ApiService', error: e);
    }
    return null;
  }

  // Example POST request
  Future<ApiResponse?> postRequest(String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return ApiResponse(statusCode: response.statusCode, body: response.body);
    } catch (e) {
      developer.log('POST error', name: 'ApiService', error: e);
    }
    return null;
  }
}
