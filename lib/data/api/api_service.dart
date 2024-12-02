import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:submission_1_restaurant_app/data/model/detail_restaurant_result.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant_result.dart';
import 'package:submission_1_restaurant_app/data/model/review.dart';
import 'package:submission_1_restaurant_app/data/model/search_result.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantResult> getAllRestaurants(http.Client client) async {
    final response = await client.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan list restoran');
    }
  }

  Future<DetailRestaurantResult> getDetailRestaurant(
      {required String id}) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan detail restoran');
    }
  }

  Future<SearchResult> searchRestaurants(String? query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan list restoran');
    }
  }

  Future<ReviewResult> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      body: json.encode(
        {
          'id': id,
          'name': name,
          'review': review,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      return ReviewResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambahkan review');
    }
  }
}
