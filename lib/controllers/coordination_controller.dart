import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/database/database_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:panda_power/models/settings.dart';

enum GameStatus {
  isNewGame,
  isOldGame
}

class CoordinationController {

  DatabaseRepository repo;
  FlutterLocalNotificationsPlugin localNotifications;
  Settings settings;
  GameState state;
  MotionController motionController;

  //ValueNotifier<UserState> userState = new ValueNotifier(UserState.sedentary);
  //ValueNotifier<double> averageVectorMagnitude = new ValueNotifier(double);
  //MotionController motionController;
  UIController uiController;
  //var timeSinceActive;
  //var timeActive;
  Timer timer;

  CoordinationController() {
    //this.userState.value = UserState.sedentary;
    //this.motionController = new MotionController();
    this.uiController = new UIController();
    this.motionController = new MotionController();

    //_loadState();

    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    localNotifications = new FlutterLocalNotificationsPlugin();

    localNotifications.initialize(initializationSettings);

  }

  /*Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );
  }*/

  Future<GameStatus> loadState() async {

    print('loading state');

    return new Future.sync(() async {
      DatabaseRepository repo = DatabaseRepository.instance;
      this.state = await repo.queryState(1);

      if (state == null) {
        print('no game state');
        this.settings = new Settings(1, false, '', '');

        return Future.value(GameStatus.isNewGame);

      } else {
        print('state load as ${state.id}: ${state.userName} ${state.pandaName} ${state.isDemo}');
        this.settings = new Settings(state.id, state.isDemo, state.pandaName, state.userName);
        return Future.value(GameStatus.isOldGame);
      }
    });


  }

  Map _gameToMap() {
    var settingsMap = this.settings.toMap();

    var map = {
      columnId: settingsMap['id'],
      pandaNameColumn: settingsMap['pandaName'],
      userNameColumn: settingsMap['userName'],
      isDemoColumn: settingsMap['isDemo'],
    };

    return map;
  }

  _saveState() async {

    Map map = _gameToMap();

    GameState state = GameState.fromMap(map);
    DatabaseRepository repo = DatabaseRepository.instance;
    int id = await repo.saveState(state);
    print('saved state: $id');
  }

  changeUserInfo(String panda, String user) {
    print('saving');
    this.settings.pandaName = panda;
    this.settings.userName = user;
    _saveState();
  }

  Future<void> sendNote() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item id 2');
  }

}

class UIController {

}



