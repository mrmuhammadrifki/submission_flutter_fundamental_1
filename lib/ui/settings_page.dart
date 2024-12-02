import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_1_restaurant_app/provider/preferences_provider.dart';
import 'package:submission_1_restaurant_app/provider/scheduling_provider.dart';
import 'package:submission_1_restaurant_app/utils/custom_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling Restaurants'),
            trailing: Consumer2<SchedulingProvider, PreferencesProvider>(
              builder: (context, scheduled, preferences, _) {
                return Switch.adaptive(
                  value: preferences.isDailyRestaurantActive,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledRestaurant(value);
                      preferences.enableDailyRestaurant(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
