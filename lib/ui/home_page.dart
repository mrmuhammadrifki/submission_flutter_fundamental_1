import 'package:flutter/material.dart';
import 'package:submission_1_restaurant_app/ui/restaurant_list_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RestaurantListPage(),
    );
  }
}
