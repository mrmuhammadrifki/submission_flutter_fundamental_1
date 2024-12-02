import 'package:submission_1_restaurant_app/data/model/customer_review.dart';

class ReviewResult {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  ReviewResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> json) => ReviewResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
