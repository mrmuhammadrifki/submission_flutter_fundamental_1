import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant.dart';
import 'package:submission_1_restaurant_app/provider/database_provider.dart';
import 'package:submission_1_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

class FavoritePage extends StatefulWidget {
  static const routeName = '/restaurant_list';
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          final restaurants = provider.favorites;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(context, restaurants[index]);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
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
          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
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
          arguments: restaurant.id,
        );
      },
    );
  }
}
