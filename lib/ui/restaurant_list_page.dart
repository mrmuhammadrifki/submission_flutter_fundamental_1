import 'package:flutter/material.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant.dart';
import 'package:submission_1_restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];

  Future<void> _loadRestaurants() async {
    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/local_restaurant.json');
    final List<Restaurant> restaurants = parseRestaurants(jsonString);
    setState(() {
      _restaurants = restaurants;
      _filteredRestaurants = restaurants;
    });
  }

  void _filterRestaurants(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRestaurants = _restaurants;
      });
    } else {
      setState(() {
        _filteredRestaurants = _restaurants
            .where((restaurant) =>
                restaurant.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'Cari restoran...',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: _filterRestaurants,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildList(context)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    if (_filteredRestaurants.isEmpty) {
      return const Center(child: Text('No restaurants found.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        return _buildRestaurantItem(context, _filteredRestaurants[index]);
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Hero(
        tag: restaurant.pictureId,
        child: Image.network(
          restaurant.pictureId,
          width: 100,
        ),
      ),
      title: Text(
        restaurant.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.map),
              const SizedBox(width: 3),
              Text(restaurant.city),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow[600],
              ),
              const SizedBox(width: 3),
              Text(restaurant.rating.toString()),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RestaurantDetailPage.routeName,
          arguments: restaurant,
        );
      },
    );
  }
}
