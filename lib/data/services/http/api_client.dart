import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../local/secure_prefs_service.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();

  /// Resolve host dynamically based on environment
  static String get _host {
    if (kIsWeb) return 'http://127.0.0.1';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2';
    } catch (_) {}
    return 'http://127.0.0.1';
  }

  static String get userServiceUrl => '$_host:8081';
  static String get recipeServiceUrl => '$_host:8082';
  static String get logServiceUrl => '$_host:8083';

  Map<String, String> _buildHeaders({String? customLanguage}) {
    final lang = customLanguage ?? SecurePrefsService.instance.getLanguageCode();
    final token = SecurePrefsService.instance.getAuthToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': lang,
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get(Uri uri, {String? customLanguage}) async {
    final response = await _client.get(
      uri,
      headers: _buildHeaders(customLanguage: customLanguage),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(Uri uri, {Object? body, String? customLanguage}) async {
    final response = await _client.post(
      uri,
      headers: _buildHeaders(customLanguage: customLanguage),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(Uri uri, {Object? body, String? customLanguage}) async {
    final response = await _client.put(
      uri,
      headers: _buildHeaders(customLanguage: customLanguage),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }

    String errorMsg = 'HTTP ${response.statusCode} error';
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map && decoded['error'] != null) {
        errorMsg = decoded['error'].toString();
      }
    } catch (_) {}

    throw ApiException(response.statusCode, errorMsg);
  }
}
