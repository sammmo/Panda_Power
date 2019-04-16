import 'dart:async';

import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/enums.dart';
import 'package:flutter/foundation.dart';

class CoordinationController {

  ValueNotifier<UserState> userState = new ValueNotifier(UserState.sedentary);
  //ValueNotifier<double> averageVectorMagnitude = new ValueNotifier(double);
  //MotionController motionController;
  UIController uiController;
  var timeSinceActive;
  var timeActive;
  Timer timer;

  CoordinationController() {
    //this.userState.value = UserState.sedentary;
    //this.motionController = new MotionController();
    this.uiController = new UIController();

  }

  void startTimer() {
    if (this.timer.isActive) {
      this.timer.cancel();

      this.timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => {

      });
    }

    if (!this.timer.isActive) {
      this.timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => {

      });
    }

  }

  void changeState() {

    if (userState.value == UserState.sedentary) {
      userState.value = UserState.active;
    } else if (userState.value == UserState.active) {
      userState.value = UserState.sedentary;
    }

  }

}

class UIController {




}