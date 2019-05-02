import 'package:panda_power/database/database_repository.dart';

import 'main_page.dart';

class GameState { //model

  int id;
  String pandaName;
  String userName;
  bool isDemo;
  PandaState pandaState;
  double powerBarValue;
  double powerBarGoal;

  GameState(this.id, this.pandaName, this.userName, this.isDemo, this.pandaState, this.powerBarValue, this.powerBarGoal);

  static fromMap(Map map) {
    var isDemo = false;

    if (map[isDemoColumn] != null && map[isDemoColumn] == true) {
      isDemo = true;
    }

    var panda = PandaState.blink;

    switch(map[pandaStateColumn]) {
      case 'PandaState.blink':
        panda = PandaState.blink;
        break;
      case 'PandaState.exercise':
        panda = PandaState.exercise;
        break;
      case 'PandaState.sleep':
        panda = PandaState.sleep;
        break;
      case 'PandaState.tickle':
        panda = PandaState.tickle;
        break;
      default:
        panda = PandaState.blink;
        break;
    }

    return new GameState(
      map[columnId], map[pandaNameColumn], map[userNameColumn], isDemo,
      panda, map[powerBarValueColumn], map[powerBarGoalValueColumn],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      pandaNameColumn: pandaName,
      userNameColumn: userName,
      isDemoColumn: isDemo,
      pandaStateColumn: pandaState.toString(),
      powerBarValueColumn: powerBarValue,
      powerBarGoalValueColumn: powerBarGoal,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

}