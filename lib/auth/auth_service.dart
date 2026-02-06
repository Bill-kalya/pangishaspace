import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _baseUrl = 'http://localhost:8080/api';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await _storage.write(key: 'jwt', value: token);
      return true;
    }
    return false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<String?> getRole() async {
    final token = await getToken();
    if (token == null) return null;
    return JwtDecoder.decode(token)['role'];
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }
}
