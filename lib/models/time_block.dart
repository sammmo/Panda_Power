import 'package:panda_power/enums.dart';

enum ActivityType {
  jogging,
  walking,
  cooking,
  cleaning
}

/*

 */

class TimeBlock {

  List<UserState> trackedStates = [];
  int sedentaryCount = 0;
  int secondsSedentary;
  int secondsTilEnding;
  bool isSuspended = false;

  TimeBlock(this.secondsSedentary, this.secondsTilEnding);

  trackState(UserState state) {
    trackedStates.add(state);

    if (state == UserState.sedentary) {
      sedentaryCount++;
      if ((sedentaryCount * 5) >= secondsSedentary
      && isSuspended == false) {
        isSuspended = true;
      }

      if ((sedentaryCount * 5) >= (secondsTilEnding - secondsSedentary)) {
       // _tearDownBlock();
      }
    }

    if (state == UserState.active) {
      sedentaryCount = 0;

      if (isSuspended == true) {
        isSuspended = false;
      }
    }
  }

  _suspend() {

  }

  _resume() {

  }

  _tearDown() {

  }
}