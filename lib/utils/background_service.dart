import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:submission_1_restaurant_app/data/api/api_service.dart';
import 'package:submission_1_restaurant_app/main.dart';
import 'package:submission_1_restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper notificationHelper = NotificationHelper();

    var result = await ApiService().getAllRestaurants(http.Client());
    var restaurantList = result.restaurants.toList();
    var randomIndex = Random().nextInt(restaurantList.length);
    var randomRestaurant = restaurantList[randomIndex];
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, randomRestaurant);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
