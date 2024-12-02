import 'package:submission_1_restaurant_app/data/model/restaurant.dart';

class SearchResult {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );
}
