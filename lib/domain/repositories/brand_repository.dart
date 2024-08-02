import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/domain/models/brand.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BrandRepository {
  BrandRepository();

  Future<List<Brand>> getBrands() async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.urlApi}/products/brands'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['resp']) {
          final List<dynamic> data = jsonResponse['brands'];
          print(jsonResponse);
          return data.map((item) => Brand.fromJson(item)).toList();
        } else {
          throw Exception('Failed to load brands: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load brands: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load brands: $e');
    }
  }
}
