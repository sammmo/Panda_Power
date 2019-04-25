import 'package:flutter/material.dart';
import 'package:panda_power/enums.dart';

enum ActivityType {
  jogging,
  walking,
  cooking,
  cleaning
}

/*
first rule of a time block: to be considered active, the entire block has to
have a ratio of 70% active
 */

class TimeBlock {

  DateTime startTime;
  DateTime endTime;
  UserState startState;
  ValueNotifier<bool> isActive = new ValueNotifier(true);

  List<UserState> trackChanges = [];
  List<UserState> trackStates = [];

  TimeBlock(this.startTime, this.startState);

  trackState(UserState state) {
    if (state == startState) {
      trackStates.add(state);
    }

    if (state != startState) {
      trackChanges.add(state);
    }

    if (((trackStates.length + trackChanges.length)  / (trackChanges.length)) > 3) {
      //average of the states
    }

    if (trackChanges.length > 3) { //if user state has been changed for more than 3 mins

      _tearDownBlock();
    }
  }

  _tearDownBlock() {
    //persist block to DB
    //give to coordcontroller or motion controller??
    //if it was active, the coordination controller should survey user
    isActive.value = false;
  }
}