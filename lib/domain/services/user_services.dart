import 'dart:convert';
import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/data/local_storage/secure_storage.dart';
import 'package:fitsole_flutter/domain/models/response/response_default.dart';
import 'package:fitsole_flutter/domain/models/response/response_user.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<ResponseDefault> addNewUser(
      String username, String email, String password) async {
    print('username: $username, email: $email, password: $password');

    final response = await http.post(
      Uri.parse('${Environment.urlApi}/user/signup'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullName': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return ResponseDefault.fromJson(jsonResponse);
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Invalid JSON format');
      }
    } else {
      final jsonResponse = jsonDecode(response.body);

      throw ResponseDefault.fromJson(jsonResponse).message;
    }
  }

  Future<ResponseDefault> verifyOTP(String otp, String email) async {
    final response = await http.post(
      Uri.parse('${Environment.urlApi}/user/verify-otp'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return ResponseDefault.fromJson(jsonResponse);
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Invalid JSON format');
      }
    } else {
      final jsonResponse = jsonDecode(response.body);

      throw ResponseDefault.fromJson(jsonResponse).message;
    }
  }

  Future<User> getUserById() async {
    final token = await secureStorage.readToken();

    if (token == null) {
      print('Token is missing');
      throw Exception('Token is missing');
    }

    final response = await http.get(
      Uri.parse('${Environment.urlApi}/user/get-user-by-id'),
      headers: {
        'Accept': 'application/json',
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      return ResponseUser.fromJson(jsonDecode(response.body)).user;
    } else {
      throw Exception('Failed to fetch user: ${response.reasonPhrase}');
    }
  }

  Future<ResponseDefault> updatePictureProfile(String image) async {
    final token = await secureStorage.readToken();

    if (token == null) {
      throw Exception('Token is missing');
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${Environment.urlApi}/user/update-picture-profile'),
    )
      ..headers['Accept'] = 'application/json'
      ..headers['xxx-token'] = token
      ..files.add(await http.MultipartFile.fromPath('image', image));

    final response = await request.send();
    final data = await http.Response.fromStream(response);

    if (data.statusCode == 200) {
      return ResponseDefault.fromJson(jsonDecode(data.body));
    } else {
      throw Exception('Failed to update profile picture: ${data.reasonPhrase}');
    }
  }

  Future<ResponseDefault> updateInformationUser(String name, String last,
      String phone, String address, String reference) async {
    final token = await secureStorage.readToken();

    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.put(
      Uri.parse('${Environment.urlApi}/user/update-information-user'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', // Ensure proper content type
        'xxx-token': token,
      },
      body: jsonEncode({
        'firstname': name,
        'lastname': last,
        'phone': phone,
        'address': address,
        'reference': reference,
      }), // Encode body as JSON string
    );

    if (response.statusCode == 200) {
      return ResponseDefault.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update user information: ${response.reasonPhrase}');
    }
  }

  Future<ResponseDefault> updateStreetAddress(
      String address, String reference) async {
    final token = await secureStorage.readToken();

    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.put(
      Uri.parse('${Environment.urlApi}/user/update-street-address'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json', // Ensure proper content type
        'xxx-token': token,
      },
      body: jsonEncode({
        'address': address,
        'reference': reference,
      }), // Encode body as JSON string
    );

    if (response.statusCode == 200) {
      return ResponseDefault.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update street address: ${response.reasonPhrase}');
    }
  }
}

final userServices = UserServices();
