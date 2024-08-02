import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/domain/models/Category.dart';
import 'package:fitsole_flutter/domain/models/brand.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryRepository {
  CategoryRepository();

  Future<List<ShoeCategory>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.urlApi}/products/categories'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['resp']) {
          final List<dynamic> data = jsonResponse['shoecategory'];
          print(data.map((item) => ShoeCategory.fromJson(item)).toList());
          return data.map((item) => ShoeCategory.fromJson(item)).toList();
        } else {
          throw Exception(
              'Failed to load category: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load categories: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
