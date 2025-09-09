import 'dart:convert';
import 'package:admin_app/core/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final ApiService api;
  final _storage = const FlutterSecureStorage();

  AuthService(this.api);

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final res = await api.post(
      '/api/user/auth/admin/login',
      {'adminId': username, 'password': password},
      withAuth: false, // 로그인은 토큰 필요 없음!
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
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
        value: '$accessTokenExpiresAt',
      );
      await _storage.write(
        key: 'refreshTokenExpiresAt',
        value: '$refreshTokenExpiresAt',
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
