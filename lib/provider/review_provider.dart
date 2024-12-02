import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:submission_1_restaurant_app/data/api/api_service.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  ResultState? _state;
  String _message = '';

  String get message => _message;

  ResultState? get state => _state;

  Future<dynamic> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final results =
          await apiService.addReview(id: id, name: name, review: review);
      if (results.customerReviews.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _message = results.message;
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
}
