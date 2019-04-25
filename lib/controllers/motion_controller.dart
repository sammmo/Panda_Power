//Intended to detect and process accelerometer data
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:panda_power/enums.dart';
import 'package:panda_power/models/reading.dart';
import 'package:sensors/sensors.dart';


class MotionController {

  int stateInterval = 30; //tests activity state after thirty seconds
  int inactivityReminderInterval = 1; //minutes

  List lastDataArray;
  List oneSecondAverageArray;
  List activeArray;

  StreamController<UserState> oneSecondStreamController = new StreamController<UserState>();
  StreamController<UserState> fiveSecondStreamController = new StreamController<UserState>();


  updateOneSecond(UserState state) => this.oneSecondStreamController.add(state);
  updateFiveSeconds(UserState state) => this.fiveSecondStreamController.add(state);
  
  ValueNotifier<UserState> longTermState = new ValueNotifier(UserState.sedentary);
  ValueNotifier<UserState> userState = new ValueNotifier(UserState.sedentary);

  ValueNotifier<double> oneSecondAverage = new ValueNotifier(0.0);
  ValueNotifier<double> fiveSecondAverage = new ValueNotifier(0.0);

  ValueNotifier<Reminder> reminder = new ValueNotifier(new Reminder('Panda is watching you'));

  Timer timer;
  Timer inactivityTimer;
  Timer activityTimer;
  //ValueNotifier<VectorMagnitude> magnitude = new ValueNotifier(VectorMagnitude.lessThan70);

  MotionController() {

    this.lastDataArray = [];
    this.oneSecondAverageArray = [];
    this.activeArray = [];
    //subscribe to accelerometer events
    accelerometerEvents.listen((AccelerometerEvent a) => {
      lastDataArray.add(new Reading(a.x, a.y, a.z, DateTime.now()).vectorMag)
    });

    //set timer to average the past second of readings (approx 100/sec)
    this.timer = new Timer.periodic(Duration(seconds: 1), (Timer t) => {
      //smoothReadings()
      //print('Timer ' + DateTime.now().toString()),
      smoothReadings()
    });
  }
  
  void startInactivityTimer() {
    print('inactivity timer running');

    if (inactivityTimer != null) {
      inactivityTimer.cancel();

      inactivityTimer = new Timer(Duration(minutes: inactivityReminderInterval), () => remindToMove());
    }
    
    if(inactivityTimer == null) {
      this.inactivityTimer = new Timer(Duration(minutes: inactivityReminderInterval), () => remindToMove());
    }
  }

  void remindToMove() {
    this.reminder.value = new Reminder('Time to move!');
  }

  void smoothReadings() {

    print(DateTime.now().toString() + ' smoothing');

    if (lastDataArray.isNotEmpty) {

      List readings = [];
      readings.addAll(lastDataArray);
      lastDataArray.clear();


      //print(readings.length);


      var sum = 0.0;

      for (var i = 0; i < readings.length; i++) {
        sum += readings[i];

        //print(sum);

        if (i == readings.length - 1) {
          var average = (sum / readings.length);
          oneSecondAverage.value = average;

          if (average >= 70) {
            updateOneSecond(UserState.active);
          }

          if (average <= 69) {
            updateOneSecond(UserState.sedentary);
          }

          oneSecondAverageArray.add(average);

          if (oneSecondAverageArray.length == 5) {
            smoothFiveSeconds();
          }
          //print(sum);

          //print("One second average " + (sum / readings.length).toString());
        }
      }

    } else print('readings empty');
  }

  void smoothFiveSeconds() {
    print('smoothing five seconds');
    List readings = [];

    readings.addAll(oneSecondAverageArray);

    oneSecondAverageArray.clear();

    var sum = 0.0;

    for (var i = 0; i < readings.length; i++) {
      sum += readings[1];

      if (i == readings.length - 1) {
        fiveSecondAverage.value = (sum / readings.length);

        if (fiveSecondAverage.value > 70.0) {

          activeArray.add(UserState.active);
          updateFiveSeconds(UserState.active);

          if (userState.value != UserState.active) {
            userState.value = UserState.active;

          }
        }

        if (fiveSecondAverage.value < 70.0) {

          activeArray.add(UserState.sedentary);
          updateFiveSeconds(UserState.sedentary);

          if (userState.value != UserState.sedentary) {
            userState.value = UserState.sedentary;
          }
        }
        //print("Five second average = " + (sum / readings.length).toString());
      }
    }

    if (activeArray.length == (stateInterval / 5)) {

      print('taking state of last 30 secs');
      print('Active array' + activeArray.toString());

      var activityReadings = [];
      activityReadings.addAll(activeArray);

      activeArray.clear();
      print(activityReadings);
      print(activeArray);

      var activeCount = 0;
      var sedentaryCount = 0;

      for (var i = 0; i < activityReadings.length; i++) {
        if (activityReadings[i] == UserState.active) {
          activeCount++;
        }

        if (activityReadings[i] == UserState.sedentary) {
          sedentaryCount++;
        }
      }

      print(activeCount / sedentaryCount);

      if ((activeCount / sedentaryCount) > 1) {

        //user was active most of the last 30 seconds

        if (longTermState.value != UserState.active) {
          longTermState.value = UserState.active;
          print(longTermState.value);
        }
      } else {
        //user was sedentary
        if (longTermState.value != UserState.sedentary) {
          longTermState.value = UserState.sedentary;
          startInactivityTimer();
          //ask user what they were doing?
        }
      }
    }
  }



}

class Reminder {

  String reminder;

  Reminder(this.reminder);

}