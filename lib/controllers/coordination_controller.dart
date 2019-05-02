import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/database/database_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:panda_power/models/game_state.dart';
import 'package:panda_power/models/local_notifier.dart';
import 'package:panda_power/models/main_page.dart';
import 'package:panda_power/models/power_bar.dart';
import 'package:panda_power/models/settings.dart';
import 'package:flutter/services.dart';

import '../enums.dart';

enum GameStatus { isNewGame, isOldGame }

class CoordinationController {
  DatabaseRepository repo;

  Settings settings;
  //GameState state;
  MotionController motionController;
  MainPageModel mainPageModel;
  LocalNotifier notifier;
  ValueNotifier<UserState> userState = new ValueNotifier(UserState.sedentary);
  ValueNotifier<PandaState> pandaState = new ValueNotifier(PandaState.sleep);
  Timer timer;

  //ValueNotifier<double> powerBar = new ValueNotifier(0.0);
  PowerBar powerBar;

  CoordinationController() {
    this.motionController = new MotionController();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  }

  startMotionSensing() {

    this.motionController.activityStreamController.stream.listen((amt) {
      addValueToPowerBar(amt.toDouble());
      print('adding $amt');
    });

    motionController.oneSecondStreamController.stream.listen((state) {
      if (motionController.longTermState.value != UserState.active) {
        changeUserState(state);
      } else {
        pandaState.value = PandaState.exercise;
      }

    });

    this.motionController.startMotionSensing();
  }

  suspendNotifications() {
    print('suspending');
    motionController.setNotifications(false);
    print(motionController.notifications);
  }

  resumeNotifications() {
    motionController.notifications = true;
  }

  changeUserState(UserState state) {
   // if (userState.value != state) {
      userState.value = state;
      switch(userState.value) {
        case UserState.active:
          pandaState.value = PandaState.blink;
          break;
        case UserState.sedentary:
          pandaState.value = PandaState.sleep;
          break;
        default:
          pandaState.value = PandaState.sleep;
          break;
      }
    //}
  }

  Future<GameStatus> loadState() async {
    print('loading state');

    return new Future.sync(() async {
      DatabaseRepository repo = DatabaseRepository.instance;
      var state = await repo.queryState(1);

      if (state == null) {
        print('no game state');
        this.settings = new Settings(1, false, '', '');
        this.mainPageModel = new MainPageModel(PandaState.sleep, 0);
        this.powerBar = new PowerBar(100, 0);

        return Future.value(GameStatus.isNewGame);
      } else {
        this.settings = new Settings(
            state.id, state.isDemo, state.pandaName, state.userName);
        this.powerBar = new PowerBar(state.powerBarGoal, state.powerBarValue);
        this.pandaState.value = state.pandaState;
        this.mainPageModel = new MainPageModel(state.pandaState, state.powerBarValue);

        return Future.value(GameStatus.isOldGame);
      }
    });
  }

  deleteGame() async {
    print('deleting game');

    DatabaseRepository repo = DatabaseRepository.instance;
    var deletedAmt = await repo.deleteGame(settings.id);

    print(deletedAmt.toString() + " was deleted");
    this.settings = new Settings(1, false, 'Panda', 'User');
    this.mainPageModel = new MainPageModel(PandaState.sleep, 0);
    this.userState.value = UserState.sedentary;
    this.powerBar = new PowerBar(100, 0);
    this.motionController.close();
    this.motionController = new MotionController();
  }

  Map _gameToMap() {
    var settingsMap = this.settings.toMap();
    var mainPageMap = this.mainPageModel.toMap();

    return {
      columnId: settingsMap['id'],
      pandaNameColumn: settingsMap['pandaName'],
      userNameColumn: settingsMap['userName'],
      isDemoColumn: settingsMap['isDemo'],
      pandaStateColumn: mainPageMap['pandaState'],
      powerBarValueColumn: powerBar.current.value,
      powerBarGoalValueColumn: powerBar.max
    };
  }

  _saveState() async {
    //organize all variables into one gamestate
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
    //messages
    this.motionController.notifier.userName = user;
    this.motionController.notifier.pandaName = panda;
    _saveState();
  }

  addValueToPowerBar(double newVal) {
    print('adding value to power bar');
    this.powerBar.addToCurrent(newVal / 100);
    //this.mainPageModel.powerBarValue = this.powerBar.value;
    _saveState();
  }


}