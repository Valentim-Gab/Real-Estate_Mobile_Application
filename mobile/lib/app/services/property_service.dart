import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/app/constants/error_constants.dart';
import 'package:mobile/app/env/environment.dart';
import 'package:mobile/app/models/property.dart';
import 'package:mobile/app/models/user.dart';
import 'package:mobile/app/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/app/views/android/components/toasts.dart';
import 'package:dio/dio.dart';

import '../database/login_dao.dart';

class PropertyService {
  final propertyUrl = '${Enviroment.apiUrl}/property';
  final viaCepUrl = Enviroment.viaCepUrl;

  Future<List<Property>> getPropertiesMe() async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/@me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Property> listProperties = List<Property>.from(json.map((item) {
        return Property.fromJson(item);
      }));

      return listProperties;
    }

    return [];
  }

  Future<Property?> getProperty(int id, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Property property = Property.fromJson(json);

      return property;
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

  Future<List<int>?> getMainImg(String img, context) async {
    final String token = await LoginDao().getToken();
    final url = '$propertyUrl/main_img/$img';
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
      Toasts().showError('Erro no servidor', context);
    }
    return null;
  }

  Future<dynamic> getAddressByZipCode(String zipCode, context) async {
    final url = Uri.parse('$viaCepUrl/$zipCode/json');
    final response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);

      return json;
    }

    return null;
  }

  Future<void> save(
      Property property, context, http.MultipartFile? multipartFile) async {
    if (multipartFile == null) {
      return;
    }

    final String token = await LoginDao().getToken();
    final url = Uri.parse(propertyUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request = http.MultipartRequest('POST', url);
    request.fields['property'] = jsonEncode(property.toMap());

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    final response = await request.send();
    final jsonResponse = await response.stream.bytesToString();
    final json = jsonDecode(jsonResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Propriedade adicionada', context);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError('Falha no cadastro', context);
    }
  }

  Future<void> update(Property property, int id, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final body = jsonEncode(property.toMap());
    final response = await http.patch(url, headers: headers, body: body);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Imóvel atualizado', context);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError(json['message'], context);
    }
  }

  Future<void> updateWithFile(Property property, int id, context,
      http.MultipartFile? multipartFile) async {
    if (multipartFile == null) {
      return;
    }

    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/$id/file');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final request = http.MultipartRequest('PATCH', url);
    request.fields['property'] = jsonEncode(property.toMap());

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    final response = await request.send();
    final jsonResponse = await response.stream.bytesToString();
    final json = jsonDecode(jsonResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Propriedade atualizada', context);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError('Falha ao atualizar', context);
    }
  }

  Future<void> delete(int id, context) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.delete(url, headers: headers);
    final json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Toasts().showSuccess('Propriedade removida', context);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (json['error'] == ErrorConstants.invalidToken ||
        json['error'] == ErrorConstants.sessionExpired ||
        json['error'] == ErrorConstants.unauthenticated) {
      Toasts().showError(json['message'], context);
      LoginDao().logout(context);
    } else {
      Toasts().showError('Falha ao remover', context);
    }
  }

  Future<void> uploadImageUpdate(
      http.MultipartFile multipartFile, context, int id) async {
    final String token = await LoginDao().getToken();
    final url = Uri.parse('$propertyUrl/main_img/$id');
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
