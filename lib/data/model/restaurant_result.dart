import 'package:submission_1_restaurant_app/data/model/restaurant.dart';

class RestaurantResult {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantResult({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantResult.fromJson(Map<String, dynamic> json) {
    return RestaurantResult(
      error: json['error'] ?? true,
      message: json['message'] ?? 'Unknown error',
      count: json['count'] ?? 0,
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => Restaurant.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
