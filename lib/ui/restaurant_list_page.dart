import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_1_restaurant_app/common/styles.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant.dart';
import 'package:submission_1_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission_1_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    await Provider.of<RestaurantsProvider>(context, listen: false)
        .fetchAllRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          color: secondaryColor,
          onRefresh: _onRefresh,
          child: Consumer<RestaurantsProvider>(
            builder: (context, provider, _) {
              if (provider.state == ResultState.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              } else if (provider.state == ResultState.hasData) {
                return ListView(
                  children: [
                    _buildSearch(),
                    _buildList(context),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    _buildSearch(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(provider.message),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<RestaurantsProvider>(
        builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                autofocus: false,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: 'Cari nama restoran...',
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
                onChanged: provider.searchRestaurants,
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, provider, child) {
        final restaurants = provider.restaurantsResult;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return _buildRestaurantItem(context, restaurants[index]);
          },
        );
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
