import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/database/database_repository.dart';
import 'package:panda_power/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CoordinationController {

  DatabaseRepository repo;
  FlutterLocalNotificationsPlugin localNotifications;
  GameState state;
  String pandaName;
  String userName;
  bool isNewGame;
  int id = 1;

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

    _loadState();

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

  _loadState() async {

    DatabaseRepository repo = DatabaseRepository.instance;
    this.state = await repo.queryState(1);

    if (state == null) {
      print('no game state');
      isNewGame = true;

    } else {
      print('state load as $columnId: ${state.userName} ${state.pandaName}');
      this.userName = state.userName;
      this.pandaName = state.pandaName;
      isNewGame = false;
    }
  }

  _saveState() async {
    GameState state = GameState();
    state.id = this.id;
    state.pandaName = this.pandaName;
    state.userName = this.userName;
    DatabaseRepository repo = DatabaseRepository.instance;
    int id = await repo.saveState(state);
    print('saved state: $id');
  }

  changeUserInfo({String panda, String user}) {
    print('saving');
    this.pandaName = panda;
    print(this.pandaName);
    this.userName = user;
    print(this.userName);
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

  Widget newGameMenu() {
    //return NewGameMenu();
  }

}

class NewGameMenu extends StatefulWidget {

  final coordinationController;

  NewGameMenu(this.coordinationController, {Key key}) : super(key: key);

  @override
  _NewGameMenuState createState() => _NewGameMenuState();
}

class _NewGameMenuState extends State<NewGameMenu> {
  String message;
  String pandaName;
  String userName;

  _changePandaName(String name) {
    setState(() {
      this.pandaName = name.trim();
      _changeMessage();
      print(this.pandaName);
    });
  }

  _changeUserName(String name) {
    setState(() {
      this.userName = name.trim();
      _changeMessage();
    });
  }

  _changeMessage() {

    var user = '';
    var panda = '';
    var append = '';
    var mess;

    if (this.pandaName != null) {
      panda = ', ' + pandaName;
    } else {
      append += ' Please give me a name!';
    }

    if (this.userName != null) {
      user = ', ' + userName;
    } else {
      append += ' Introduce yourself!';
    }

    mess = 'Hi' + user + '! Im your panda' + panda + '.' + append;

    setState(() {
      this.message = mess;
    });
  }

  @override
  initState() {

    super.initState();

    if (widget.coordinationController.pandaName != null) {
      _changePandaName(widget.coordinationController.pandaName);
    }

    if (widget.coordinationController.userName != null) {
      _changeUserName(widget.coordinationController.userName);
    }

    _changeMessage();

  }

  _save() {
    //TODO: put in null field error checks ugh
    if (this.userName == null) {
      this.userName = 'User';
    }

    if (this.pandaName == null) {
      this.pandaName = 'Cocoa';
    }
    widget.coordinationController.changeUserInfo(panda: this.pandaName, user: this.userName);
    Navigator.pushReplacementNamed(context, '/main_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(message == null? '' : message),
            Text('Your Pandas Name: '),
            Text(pandaName == null? 'Loading' : pandaName),
            TextEntryWidget(onChanged: (name) => _changePandaName(name)),
            Text('Your name: '),
            Text(userName == null? '' : userName),
            TextEntryWidget(onChanged: (name) => _changeUserName(name)),
            RaisedButton(onPressed: _save,
            child: Text('Done')),
          ],
        ),
      )
    ) ;
  }
}

class TextEntryWidget extends StatelessWidget {
  final onChanged;

  const TextEntryWidget({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(

      ),
      textCapitalization: TextCapitalization.words,
      onSubmitted: this.onChanged,
    );
  }
  
  
}

class MainPage extends StatelessWidget {

  final coordinationController;

  const MainPage(this.coordinationController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(coordinationController.userName),
            Text(coordinationController.pandaName),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, '/new_game'),
              child: Text('Edit info'),
            ),
            RaisedButton(
              onPressed: () => coordinationController.sendNote(),
              child: Text('send notification')
            )
          ],
        )
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Loading Panda Power'),
        ],
      )
    );
  }
}