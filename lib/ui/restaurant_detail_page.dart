import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_1_restaurant_app/common/styles.dart';
import 'package:submission_1_restaurant_app/data/model/customer_review.dart';
import 'package:submission_1_restaurant_app/data/model/detail_restaurant_result.dart';
import 'package:submission_1_restaurant_app/data/model/restaurant.dart';
import 'package:submission_1_restaurant_app/provider/database_provider.dart';
import 'package:submission_1_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission_1_restaurant_app/provider/review_provider.dart';
import 'package:submission_1_restaurant_app/utils/result_state.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final String id;
  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    await Provider.of<RestaurantsProvider>(context, listen: false)
        .fetchDetailRestaurant(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: _onRefresh,
          color: secondaryColor,
          child: Center(
            child: Consumer2<RestaurantsProvider, DatabaseProvider>(
              builder: (context, provider, databaseProvider, child) {
                if (provider.state == ResultState.hasData) {
                  final restaurant = provider.detailRestaurantResult;
                  return ListView(
                    children: [
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Hero(
                                tag: provider
                                        .detailRestaurantResult?.pictureId ??
                                    '',
                                child: restaurant?.pictureId != null
                                    ? Image.network(
                                        'https://restaurant-api.dicoding.dev/images/medium/${restaurant?.pictureId ?? ''}',
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[600],
                                        size: 32,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        restaurant?.rating.toString() ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              FutureBuilder<bool>(
                                future: databaseProvider
                                    .isFavorited(restaurant?.id ?? ''),
                                builder: (context, snapshot) {
                                  var isFavorited = snapshot.data ?? false;
                                  return Positioned(
                                    bottom: -20,
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: isFavorited
                                          ? IconButton(
                                              onPressed: () => databaseProvider
                                                  .removeFavorite(
                                                      restaurant?.id ?? ''),
                                              icon: Icon(
                                                size: 40,
                                                Icons.favorite,
                                                color: Colors.pink[600],
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () =>
                                                  databaseProvider.addFavorite(
                                                Restaurant(
                                                  id: restaurant?.id ?? '',
                                                  name: restaurant?.name ?? '',
                                                  description:
                                                      restaurant?.description ??
                                                          '',
                                                  pictureId:
                                                      restaurant?.pictureId ??
                                                          '',
                                                  city: restaurant?.city ?? '',
                                                  rating:
                                                      restaurant?.rating ?? 0.0,
                                                ),
                                              ),
                                              icon: const Icon(
                                                size: 40,
                                                Icons.favorite,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant?.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.map, color: Colors.grey[600]),
                                    const SizedBox(width: 3),
                                    Text(
                                      restaurant?.city ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(restaurant?.description ?? ''),
                                const SizedBox(height: 24),
                                const Text(
                                  'Menu Minuman',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                _buildListMenu(
                                    menus: restaurant?.menus.drinks ?? []),
                                const SizedBox(height: 24),
                                const Text(
                                  'Menu Makanan',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                _buildListMenu(
                                    menus: restaurant?.menus.foods ?? []),
                                const SizedBox(height: 24),
                                const Text(
                                  'Review',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  autofocus: false,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    hintText: 'Tulis review kamu....',
                                    fillColor: Colors.black,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  controller: _reviewController,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final reviewProvider =
                                        Provider.of<ReviewProvider>(context,
                                            listen: false);
                                    await reviewProvider.addReview(
                                      id: restaurant?.id ?? '',
                                      name: 'Muhammad Rifki',
                                      review: _reviewController.text,
                                    );

                                    _reviewController.clear();

                                    if (!mounted) return;

                                    if (reviewProvider.state ==
                                        ResultState.hasData) {
                                      await provider.fetchDetailRestaurant(
                                          id: restaurant?.id ?? '');

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            reviewProvider.message,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                    if (reviewProvider.state ==
                                        ResultState.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(reviewProvider.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Kirim'),
                                ),
                                const SizedBox(height: 8),
                                _buildListCustomerReview(
                                    provider.customerReviewResult),
                                const SizedBox(height: 100)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (provider.state == ResultState.error) {
                  return ListView(
                    children: [
                      const SizedBox(height: 300),
                      Center(
                        child: Text(provider.message),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: secondaryColor,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCustomerReview(List<CustomerReview> customerReview) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customerReview.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                customerReview[index].name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  customerReview[index].name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                customerReview[index].date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          subtitle: Text(customerReview[index].review),
        );
      },
    );
  }

  Widget _buildListMenu({required List<MenuCategory> menus}) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              menus[index].name,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
