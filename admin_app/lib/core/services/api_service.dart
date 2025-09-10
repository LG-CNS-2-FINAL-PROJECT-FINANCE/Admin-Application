import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  ApiService(this.baseUrl);
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await _storage.read(key: 'accessToken');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint, {bool withAuth = true}) async {
    final h = await _headers(withAuth: withAuth);
    return http
        .get(Uri.parse('$baseUrl$endpoint'), headers: h)
        .timeout(const Duration(seconds: 12));
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = true,
  }) async {
    final h = await _headers(withAuth: withAuth);
    return http
        .post(
          Uri.parse('$baseUrl$endpoint'),
          headers: h,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
  }
}
