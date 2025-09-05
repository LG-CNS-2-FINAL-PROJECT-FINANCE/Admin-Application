import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService(this.baseUrl);

  final String baseUrl; // 예: http://192.168.0.222:8080
  final _storage = const FlutterSecureStorage();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/user/auth/admin/login');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'adminId': username, 'password': password}),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);

      // 백엔드 응답 키에 맞춰 수정하세요
      final accessToken = json['accessToken'];
      final refreshToken = json['refreshToken'];
      final accessTokenExpiresAt = json['accessTokenExpiresAt'];
      final refreshTokenExpiresAt = json['refreshTokenExpiresAt'];

      if (accessToken == null) {
        throw Exception('토큰이 응답에 없습니다.');
      }

      await _storage.write(key: 'accessToken', value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: 'refreshToken', value: refreshToken);
      }
      await _storage.write(
        key: 'accessTokenExpiresAt',
        value: accessTokenExpiresAt,
      );
      await _storage.write(
        key: 'refreshTokenExpiresAt',
        value: refreshTokenExpiresAt,
      );
    } else if (res.statusCode == 401) {
      throw Exception('아이디 또는 비밀번호가 올바르지 않습니다.');
    } else {
      throw Exception('로그인 실패 (${res.statusCode})');
    }
  }

  Future<String?> get accessToken => _storage.read(key: 'accessToken');
  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'accessTokenExpiresAt');
    await _storage.delete(key: 'refreshTokenExpiresAt');
  }
}
