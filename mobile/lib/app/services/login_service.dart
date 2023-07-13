import 'package:mobile/app/env/environment.dart';
import 'package:mobile/app/models/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final apiUrl = Enviroment.apiUrl;

  Future<http.Response> login(Login login) async {
    final url = Uri.parse('$apiUrl/login');
    final headers = {'Content-type': 'application/json'};
    final body = jsonEncode(login.toMap());
    final response = await http.post(url, headers: headers, body: body);

    return response;
  }
}
