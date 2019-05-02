import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum PandaState {
  exercise,
  sleep,
  blink,
  tickle
}

class MainPageModel {

  PandaState pandaState;
  double powerBarValue;

  MainPageModel(this.pandaState, this.powerBarValue);

  Map toMap() {
    if (pandaState == null) {
      pandaState = PandaState.sleep;
    }
    return {
      'pandaState': pandaState,
      'powerBarValue': powerBarValue,
    };
  }

  static fromMap(Map map) {
    if (map['pandaState'] == 'PandaState.sleep') {
      return MainPageModel(PandaState.sleep, map['powerBarValue']);
    }
  }

}

class ActivityBar {
  double max;
  Stream addValue;

  var controller = new StreamController();

  ActivityBar() {

    addValue = controller.stream;
  }

  void incrementValue(double value) {
    controller.add(value);
  }
}