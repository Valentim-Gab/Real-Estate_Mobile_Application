import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app/constants/error_constants.dart';
import 'package:mobile/app/database/login_dao.dart';
import 'package:mobile/app/env/environment.dart';
import 'package:mobile/app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/app/views/android/components/toasts.dart';

class UserService {
  final userUrl = '${Enviroment.apiUrl}/user';

  // Future<List<User>> getAllUsers() async {
  //   final String token = await LoginDao().getToken();
  //   final url = Uri.parse(userUrl);
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //   final response = await http.get(url, headers: headers);
  //   final json = jsonDecode(response.body);

  //   return [];
  // }

  Future<User?> getUserLogged(context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final User user = User.fromJson(json);

      return user;
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);

      return null;
    }
    Toasts().showError('Erro no servidor', context);

    return null;
  }

  Future<bool> verifyLogin() async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: headers);

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<User?> getUser(int id, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final User user = User.fromJson(json);

      return user;
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);

      return null;
    }
    Toasts().showError('Erro no servidor', context);

    return null;
  }

  Future<List<int>?> getProfileImg(context) async {
    final String token = await LoginDao().getToken();
    final url = '$userUrl/profile_img/@me';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(headers: headers, responseType: ResponseType.bytes),
      );

      if (response.statusCode == HttpStatus.ok) {
        return response.data!;
      } else {
        Toasts().showError('Erro ao obter imagem', context);
      }
    } catch (error) {
      print('object');
      Toasts().showError('Erro no servidor', context);
    }
    return null;
  }

  Future<void> save(User user, context) async {
    final url = Uri.parse(userUrl);
    final headers = {'Content-type': 'application/json'};
    final body = jsonEncode(user.toMap());
    final response = await http.post(url, headers: headers, body: body);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Cadastro realizado', context);
      Navigator.of(context).pushNamed('/');
    } else {
      Toasts().showError(json['message'], context);
    }
  }

  Future<void> update(User user, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode(user.toMap());
    final response = await http.patch(url, headers: headers, body: body);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Cadastro atualizado', context);
      Navigator.of(context).pop();
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError(json['message'], context);
    }
  }

  Future<void> delete(context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.delete(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Conta deletada', context);
      LoginDao().logout(context);
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError(json['message'], context);
    }
  }

  Future<void> uploadImage(http.MultipartFile multipartFile, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$userUrl/profile_img/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request = http.MultipartRequest('PATCH', url);

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    final response = await http.Response.fromStream(await request.send());
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Imagem alterada', context);
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError(json['message'], context);
    }
  }
}
