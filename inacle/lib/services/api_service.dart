import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  final String _baseUrl = 'https://api.inacle.co.in/index.php/';
  final Map<String, String> headers = {
    // 'Content-Type': 'application/json',
    // 'Authorization': 'Bearer your_token',
    'X-Platform': Platform.isIOS ? 'iOS' : 'Android',
  };

  Future<String> get(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await http.get(url, headers: headers);
      return ApiResponseHandler.handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<String> post(String endpoint,
      {required Map<String, String> body}) async {
    final url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await http.post(url, headers: headers, body: body);
      log('request >>>>${response.request}');
      log('statusCode >>>>${response.statusCode}');
      log('headers >>>>${response.request?.headers.toString()}');
      log('body >>>>$body');
      log('response >>>>${response.body}');
      return ApiResponseHandler.handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<String> put(String endpoint,
      {required Map<String, String> body}) async {
    final url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await http.put(url, headers: headers, body: body);
      return ApiResponseHandler.handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<String> delete(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await http.delete(url, headers: headers);
      return ApiResponseHandler.handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<String> patch(String endpoint,
      {required Map<String, String> body}) async {
    final url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await http.patch(url, headers: headers, body: body);
      return ApiResponseHandler.handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

class ApiResponseHandler {
  static String handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // If the server returns a 200 OK response,
        // then parse the JSON.
        log('>>>>>>${response.body}');
        return response.body;
      case 400:
        throw Exception('Bad Request');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not Found');
      case 500:
        throw Exception('Internal Server Error');
      default:
        throw Exception('Failed to load data');
    }
  }
}
