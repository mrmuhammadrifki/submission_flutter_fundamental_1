import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:submission_1_restaurant_app/data/api/api_service.dart';
import 'package:submission_1_restaurant_app/data/model/customer_review.dart';
import 'package:submission_1_restaurant_app/data/model/detail_restaurant_result.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService});

  late List<Restaurant> _restaurantsResult;
  DetailRestaurant? _detailRestaurantResult;
  List<CustomerReview> _customerReviewResult = [];
  ResultState? _state;
  String _message = '';

  String get message => _message;

  List<Restaurant> get restaurantsResult => _restaurantsResult;
  DetailRestaurant? get detailRestaurantResult => _detailRestaurantResult;
  List<CustomerReview> get customerReviewResult => _customerReviewResult;

  Timer? _debounce;

  ResultState? get state => _state;

  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final results = await apiService.getAllRestaurants(http.Client());
      if (results.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsResult = results.restaurants;
      }
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Tidak ada koneksi internet';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> fetchDetailRestaurant({required String id}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final results = await apiService.getDetailRestaurant(id: id);
      if (results.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _customerReviewResult = results.restaurant.customerReviews;
        _detailRestaurantResult = results.restaurant;
        return;
      }
    } on SocketException catch (_) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Tidak ada koneksi internet';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  void searchRestaurants(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        _state = ResultState.loading;
        notifyListeners();

        final results = await apiService.searchRestaurants(query);
        if (results.restaurants.isEmpty) {
          _state = ResultState.noData;
          _message = 'Data tidak ditemukan';
        } else {
          _state = ResultState.hasData;
          _restaurantsResult = results.restaurants;
        }
        notifyListeners();
      } on SocketException catch (_) {
        _state = ResultState.error;
        _message = 'Tidak ada koneksi internet';
        notifyListeners();
      } catch (e) {
        _state = ResultState.error;
        _message = 'Error --> $e';
        notifyListeners();
      }
    });
  }
}
