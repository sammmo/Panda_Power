import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/enums.dart';
import 'package:panda_power/widgets/loading_screen.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/new_game_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final coordinationController = new CoordinationController();

  //CoordinationController coordinationController = new CoordinationController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder> {
      NewGameMenu.routeName: (BuildContext context) => new NewGameMenu(coordinationController),
      MainPage.routeName: (BuildContext context) => new MainPage(coordinationController),
      SettingsPage.routeName: (BuildContext context) => new SettingsPage(coordinationController),
    };
    return MaterialApp(
      title: 'Panda Power',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoadingScreen(coordinationController),
      routes: routes,
    );
  }
}

class SettingsPage extends StatefulWidget {

  final coordinationController;

  static const String routeName = '/SettingsPage';

  SettingsPage(this.coordinationController);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _switchValue;
  String userName;
  String pandaName;

  var _pandaNameChangeIsVisible = false;
  var _changePandaNameButtonIsVisible = true;
  var _userNameChangeIsVisible = false;
  var _changeUserNameButtonIsVisible = true;

  _showChangeUserNameBox() {

    setState(() {
      _userNameChangeIsVisible = true;
    });
  }

  _showChangePandaNameBox() {
    setState(() {
      _pandaNameChangeIsVisible = true;
      _changePandaNameButtonIsVisible = false;
    });
  }

  _changeUserName(String name) {

    setState(() {
      widget.coordinationController.settings.userName = name;
    });
  }

  _changePandaName(String name) {

    setState(() {
      _pandaNameChangeIsVisible = false;
      widget.coordinationController.settings.pandaName = name;
      pandaName = name;
      _changePandaNameButtonIsVisible = true;
    });
  }

  _changeIsDemo(bool value) {
    
    widget.coordinationController.settings.isDemo = value;

    setState(() {
      _switchValue = value;
    });
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _switchValue = widget.coordinationController.settings.isDemo;
    userName = widget.coordinationController.settings.userName;
    pandaName = widget.coordinationController.settings.pandaName;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1,),
            Row(
              children: <Widget>[
                Text('Your panda name is: $pandaName'),
                Visibility(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: TextEntryWidget(
                          onChanged: (name) => _changePandaName(name),
                        ),
                      )

                    ],
                  ),
                  visible: _pandaNameChangeIsVisible,
                ),
                Visibility(
                  child: RaisedButton(
                    child: Text('change'),
                    onPressed: () => _showChangePandaNameBox(),
                  ),
                  visible: _changePandaNameButtonIsVisible,
                )

              ],
            ),
            Row(
              children: <Widget>[
                Text('Your name is: $userName'),
                Visibility(
                  child: Row(),
                  visible: _userNameChangeIsVisible,
                )
              ],
            ),

            Row(
              children: <Widget>[
                Text('use demo settings'),
                Switch(
                  value: _switchValue,
                  onChanged: (value) => _changeIsDemo(value),
                )
              ],
            )
          ],
        ),
      ),
    );
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
      autofocus: true,
    );
  }


}



class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String activityState = '...Detecting State';
  double oneSecondAve = 0;
  double fiveSecondAve = 0;
  UserState userState = UserState.sedentary;
  UserState longTermState = UserState.sedentary;
  //CoordinationController coordinationController = new CoordinationController();
  MotionController motionController = new MotionController();
  String reminder = '';

  @override
  initState() {
    super.initState();

    motionController.oneSecondAverage.addListener(oneSecListener);
    motionController.fiveSecondAverage.addListener(fiveSecListener);
    motionController.userState.addListener(stateListener);
    motionController.longTermState.addListener(longTermStateListener);
    motionController.reminder.addListener(reminderListener);
  }

  reminderListener() {
    setState(() {
      reminder = motionController.reminder.value.reminder;
    });
  }

  longTermStateListener() {
    setState(() {
      longTermState = motionController.longTermState.value;
    });
  }

  stateListener() {
    print("CHANGE STATE");
    setState(() {
      if (motionController.userState.value == UserState.sedentary) {
        activityState = 'INACTIVE';
      }

      if (motionController.userState.value == UserState.active) {
        activityState = 'ACTIVE';
      }
    });
  }

  fiveSecListener() {
    setState(() {
      fiveSecondAve = motionController.fiveSecondAverage.value;
    });
  }

  oneSecListener() {
    setState(() {
      oneSecondAve = motionController.oneSecondAverage.value;
    });
  }


  void changeUserState() {
    setState(() {
      //userState = widget.coordinationController.userState.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              reminder,
              style: TextStyle(
                fontSize: 250,
                color: Colors.green
              ),
            ),
            Text(
              '$longTermState',
              style: TextStyle(
                fontSize: 100,
                color: Colors.blue
              ),
            ),
            Text(
              activityState,
              style: TextStyle(
                fontSize: 60,
                color: Colors.red
              ),
            ),
            Text('Prior second average:'),
            Text(
              oneSecondAve.toString()
            ),
            Text('-----------------------------------'),
            Text('Prior five second average'),
            Text(
              fiveSecondAve.toString()
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
