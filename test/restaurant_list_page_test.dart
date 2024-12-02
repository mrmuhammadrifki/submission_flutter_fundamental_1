import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:submission_1_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission_1_restaurant_app/ui/restaurant_list_page.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

import 'restaurant_list_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RestaurantsProvider>()])
void main() {
  group('Restaurant List Page Widget Test', () {
    testWidgets('Show loading widget when status is loading',
        (WidgetTester tester) async {
      final MockRestaurantsProvider mockRestaurantsProvider =
          MockRestaurantsProvider();

      when(mockRestaurantsProvider.state).thenReturn(ResultState.loading);

      await tester.pumpWidget(
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (context) => mockRestaurantsProvider,
          child: const MaterialApp(
            home: RestaurantListPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('Show ListView widget when status is loaded',
        (WidgetTester tester) async {
      final MockRestaurantsProvider mockRestaurantsProvider =
          MockRestaurantsProvider();

      when(mockRestaurantsProvider.state).thenReturn(ResultState.hasData);

      await tester.pumpWidget(
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (context) => mockRestaurantsProvider,
          child: const MaterialApp(
            home: RestaurantListPage(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
    testWidgets('Show message when data is empty', (WidgetTester tester) async {
      final MockRestaurantsProvider mockRestaurantsProvider =
          MockRestaurantsProvider();

      when(mockRestaurantsProvider.state).thenReturn(ResultState.noData);
      when(mockRestaurantsProvider.message)
          .thenReturn('Tidak ada data restoran tersedia');

      await tester.pumpWidget(
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (context) => mockRestaurantsProvider,
          child: const MaterialApp(
            home: RestaurantListPage(),
          ),
        ),
      );

      expect(find.text('Tidak ada data restoran tersedia'), findsOneWidget);
    });

    testWidgets('Show error message when status is error',
        (WidgetTester tester) async {
      final MockRestaurantsProvider mockRestaurantsProvider =
          MockRestaurantsProvider();

      when(mockRestaurantsProvider.state).thenReturn(ResultState.error);
      when(mockRestaurantsProvider.message)
          .thenReturn('Gagal mendapatkan list restoran');

      await tester.pumpWidget(
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (context) => mockRestaurantsProvider,
          child: const MaterialApp(
            home: RestaurantListPage(),
          ),
        ),
      );

      expect(find.text('Gagal mendapatkan list restoran'), findsOneWidget);
    });
  });
}
