import 'dart:convert';
import 'package:http/http.dart' as http;

/// Small HTTP client for the Raspberry Pi demo API.
///
/// Usage:
///
/// final svc = DataService('http://192.168.1.100:5000');
/// final data = await svc.fetchData();
///
class DataService {
  final String baseUrl;

  DataService(this.baseUrl) : assert(baseUrl.isNotEmpty, 'baseUrl must not be empty');

  /// Fetch telemetry from `<baseUrl>/data`.
  ///
  /// Returns a decoded JSON map on success, or `null` on failure. Callers
  /// should treat a `null` return as "no data available" and show a
  /// user-visible message if appropriate.
  Future<Map<String, dynamic>?> fetchData() async {
    try {
      final uri = Uri.parse('$baseUrl/data');
      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) {
        // Non-200 responses are treated as no-data for the demo app.
        return null;
      }
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;

      // If server returned a list or something unexpected, normalize to null.
      return Map<String, dynamic>.from(decoded as Map);
    } on FormatException catch (e) {
      // JSON parse error
      // ignore: avoid_print
      print('DataService: JSON parse error: $e');
      return null;
    } on http.ClientException catch (e) {
      // network-level client error
      // ignore: avoid_print
      print('DataService: HTTP client error: $e');
      return null;
    } catch (e) {
      // Generic fallback — log and return null so UI can continue.
      // ignore: avoid_print
      print('DataService: unexpected error: $e');
      return null;
    }
  }
}
