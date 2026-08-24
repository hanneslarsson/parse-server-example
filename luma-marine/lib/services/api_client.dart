import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Thin JSON/HTTP wrapper around the Luma Marine backend. Callers pass an
/// optional bearer token per-request rather than the client holding auth
/// state itself, so it stays a simple stateless transport.
class ApiClient {
  final http.Client _http;

  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  Uri _uri(String path) => Uri.parse('$apiBaseUrl$path');

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  dynamic _decode(http.Response response) {
    final body = response.body.isEmpty ? '{}' : response.body;
    final decoded = jsonDecode(body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }
    final message = (decoded is Map && decoded['error'] is String)
        ? decoded['error'] as String
        : 'Request failed (${response.statusCode})';
    throw ApiException(message, statusCode: response.statusCode);
  }

  Future<dynamic> get(String path, {String? token}) async {
    final response = await _http.get(_uri(path), headers: _headers(token));
    return _decode(response);
  }

  Future<dynamic> post(String path, {Object? body, String? token}) async {
    final response = await _http.post(
      _uri(path),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> put(String path, {Object? body, String? token}) async {
    final response = await _http.put(
      _uri(path),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }
}
