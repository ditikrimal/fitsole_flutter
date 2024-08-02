import 'package:fitsole_flutter/data/env/env.dart';
import 'package:fitsole_flutter/domain/models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductRepository {
  ProductRepository();

  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('${Environment.urlApi}/api/products'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Print the entire response body for debugging

      // Decode the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if 'products' key exists and is a List
      if (responseBody.containsKey('products') &&
          responseBody['products'] is List) {
        List<dynamic> productJson = responseBody['products'];

        // Convert JSON to Product objects
        List<Product> products = productJson.map((json) {
          return Product.fromJson(json);
        }).toList();

        // Print the list of Product objects

        return products;
      } else {
        throw Exception('Key "products" not found or is not a List');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchMostPopularProducts() async {
    final response = await http.get(
      Uri.parse('${Environment.urlApi}/api/products/popular'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Print the entire response body for debugging

      // Decode the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if 'products' key exists and is a List
      if (responseBody.containsKey('products') &&
          responseBody['products'] is List) {
        List<dynamic> productJson = responseBody['products'];

        // Convert JSON to Product objects
        List<Product> products = productJson.map((json) {
          return Product.fromJson(json);
        }).toList();

        // Print the list of Product objects

        return products;
      } else {
        throw Exception('Key "products" not found or is not a List');
      }
    } else {
      throw Exception('Failed to load popular products');
    }
  }

  Future<List<Product>> fetchLatestArrivals() async {
    final response = await http.get(
      Uri.parse('${Environment.urlApi}/api/products/latest'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Print the entire response body for debugging

      // Decode the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if 'products' key exists and is a List
      if (responseBody.containsKey('products') &&
          responseBody['products'] is List) {
        List<dynamic> productJson = responseBody['products'];

        // Convert JSON to Product objects
        List<Product> products = productJson.map((json) {
          return Product.fromJson(json);
        }).toList();

        // Print the list of Product objects

        return products;
      } else {
        throw Exception('Key "products" not found or is not a List');
      }
    } else {
      throw Exception('Failed to load latest arrivals');
    }
  }
}
