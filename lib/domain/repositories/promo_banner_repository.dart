import 'dart:convert';

import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/domain/models/PromoBanner.dart';
import 'package:http/http.dart' as http;

class PromoBannerRepository {
  Future<List<PromoBanner>> fetchPromoBanners() async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.urlApi}/repositories/promo-banners'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['promoBanners'];
        return data.map((item) => PromoBanner.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load promo banners');
      }
    } catch (e) {
      throw Exception('Failed to load promo banners: $e');
    }
  }
}
