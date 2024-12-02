import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_1_restaurant_app/data/api/api_service.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant_result.dart';
import 'get_all_restaurants_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('getAllRestaurants', () {
    test('returns a RestaurantResult if the http call completes successfully',
        () async {
      final client = MockClient();

      const mockJsonResponse = '''
        {
          "error": false,
          "message": "success",
          "count": 2,
          "restaurants": [
            {
              "id": "1",
              "name": "Mendoan Joss",
              "description": "Mendoan Asli Banyumas",
              "pictureId": "1",
              "city": "Purwokerto",
              "rating": 5.0
            },
            {
              "id": "2",
              "name": "Gacoan",
              "description": "Mie Pedas No 1 di Indonesia",
              "pictureId": "2",
              "city": "Bandung",
              "rating": 4.9
            }
          ]
        }
        ''';

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(mockJsonResponse, 200));

      final apiService = ApiService();
      final result = await apiService.getAllRestaurants(client);

      expect(result, isA<RestaurantResult>());
      expect(result.error, false);
      expect(result.count, 2);
      expect(result.restaurants[0].name, 'Mendoan Joss');
      expect(result.restaurants[1].rating, 4.9);
    });

    test('returns an empty RestaurantResult when there are no restaurants',
        () async {
      final client = MockClient();

      const mockJsonResponse = '''
      {
        "error": false,
        "message": "success",
        "count": 0,
        "restaurants": []
      }
      ''';

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(mockJsonResponse, 200));

      final apiService = ApiService();
      final result = await apiService.getAllRestaurants(client);

      expect(result, isA<RestaurantResult>());
      expect(result.error, false);
      expect(result.count, 0);
      expect(result.restaurants, isEmpty);
    });

    
    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final apiService = ApiService();

      expect(() async => await apiService.getAllRestaurants(client),
          throwsException);
    });
  });
}
