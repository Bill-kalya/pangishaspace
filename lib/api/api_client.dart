import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';

class ApiClient {
  final AuthService _authService = AuthService();

  Future<http.Response> get(String path) async {
    final token = await _authService.getToken();

    return http.get(
      Uri.parse(path),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> post(String path, String body) async {
    final token = await _authService.getToken();

    return http.post(
      Uri.parse(path),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }
}
