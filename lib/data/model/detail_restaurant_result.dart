import 'package:submission_1_restaurant_app/data/model/customer_review.dart';

class DetailRestaurantResult {
  bool error;
  String message;
  DetailRestaurant restaurant;

  DetailRestaurantResult({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory DetailRestaurantResult.fromJson(Map<String, dynamic> json) =>
      DetailRestaurantResult(
        error: json["error"],
        message: json["message"],
        restaurant: DetailRestaurant.fromJson(json["restaurant"]),
      );
}

class DetailRestaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<MenuCategory> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  DetailRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) =>
      DetailRestaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories: List<MenuCategory>.from(
            json["categories"].map((x) => MenuCategory.fromJson(x))),
        menus: Menus.fromJson(json["menus"]),
        rating: json["rating"]?.toDouble(),
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}

class MenuCategory {
  String name;

  MenuCategory({
    required this.name,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menus {
  List<MenuCategory> foods;
  List<MenuCategory> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<MenuCategory>.from(
            json["foods"].map((x) => MenuCategory.fromJson(x))),
        drinks: List<MenuCategory>.from(
            json["drinks"].map((x) => MenuCategory.fromJson(x))),
      );
}
