import 'dart:convert';
import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/data/local_storage/secure_storage.dart';
import 'package:fitsole_flutter/domain/models/response/response_auth.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  Future<ResponseAuth> login(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('${Environment.urlApi}/user/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final authResponse = ResponseAuth.fromJson(responseBody);
      await secureStorage.setAuthToken(authResponse.token);
      return authResponse;
    } else {
      // Handle error responses
      return ResponseAuth(
        resp: responseBody["resp"] ?? false,
        message: responseBody["message"] ?? 'An error occurred',
        messageStatus: responseBody["messageStatus"] ?? '',
        token: responseBody["token"] ?? '',
        // Default to empty string if there's an error
      );
    }
  }

  Future<ResponseAuth> renewToken() async {
    try {
      // Read the existing token from secure storage
      final token = await secureStorage.readToken();

      // Ensure token is not null or empty
      if (token == null || token.isEmpty) {
        throw Exception('Token is not available');
      }

      // Make a GET request to the token renewal endpoint
      final resp = await http.post(
        Uri.parse('${Environment.urlApi}/auth/renew-token'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('Response status: ${resp.statusCode}');
      print('Response body: ${resp.body}');

      final responseBody = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        // Successful response, return a parsed ResponseAuth object
        return ResponseAuth.fromJson(responseBody);
      } else {
        // Handle error responses, potentially with additional details
        return ResponseAuth(
          resp: responseBody["resp"] ?? false,
          message: responseBody["message"] ?? 'An error occurred',
          messageStatus: responseBody["messageStatus"] ?? '',
          token: responseBody["token"] ??
              '', // Default to empty string if there's an error
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error renewing token: $e');
      return ResponseAuth(
        resp: false,
        message: 'Error renewing token: $e',
        messageStatus: '',
        token: '', // Return an empty token on error
      );
    }
  }
}

final authServices = AuthServices();
