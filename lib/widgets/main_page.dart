import 'package:flutter/material.dart';
import 'package:panda_power/enums.dart';
import 'package:panda_power/main.dart';
import 'package:panda_power/models/settings.dart';

class MainPage extends StatefulWidget {

  final coordinationController;

  static String routeName = '/MainPage';

  const MainPage(this.coordinationController, {Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var userName;
  var pandaName;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.coordinationController.settings.userName != null) {
      this.userName = widget.coordinationController.settings.userName;
    } else {
      userName = 'User';
    }

    if (widget.coordinationController.settings.userName != null) {
      this.pandaName = widget.coordinationController.settings.pandaName;
    } else {
      pandaName = 'Panda';
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Panda Power!'),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
              Text('Panda name: $pandaName'),
              Text('User name: $userName'),
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
                child: Text('Edit Settings'),
              ),
              RaisedButton(
                  onPressed: () => widget.coordinationController.sendNote(),
                  child: Text('send notification')
              ),
              UserStateDisplay(widget.coordinationController.motionController),
              Spacer(flex: 1),
            ],
          )
      ),
    );
  }
}

class UserStateDisplay extends StatefulWidget {

  final motionController;

  UserStateDisplay(this.motionController);

  @override
  _UserStateDisplayState createState() => _UserStateDisplayState();
}

class _UserStateDisplayState extends State<UserStateDisplay> {

  var userState;
  var longTermState;

 @override
 void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('One second Average: '),
            StreamBuilder(
              stream: widget.motionController.oneSecondStreamController.stream,
              initialData: UserState.sedentary,
              builder: (context, state) {
                if (state.hasError) {
                  return Text('error');
                } else if (state.data == null) {
                  return Text('null');
                } else {
                  switch (state.data) {
                    case UserState.sedentary: return Text('sedentary', style: TextStyle(color: Colors.red, fontSize: 40),);
                    case UserState.active: return Text('active', style: TextStyle(color: Colors.green, fontSize: 40));
                  }
                }

              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Five Second Average:'),
            StreamBuilder(
              stream: widget.motionController.fiveSecondStreamController.stream,
              initialData: UserState.sedentary,
              builder: (context, state) {
                if (state.hasError) {
                  return Text('error');
                } else if (state.data == null) {
                  return Text('null');
                } else {
                  switch (state.data) {
                    case UserState.sedentary: return Text('sedentary', style: TextStyle(color: Colors.red, fontSize: 40),);
                    case UserState.active: return Text('active', style: TextStyle(color: Colors.green, fontSize: 40));
                  }
                }

              },
            ),
          ],
        )
      ],
    );
  }
}

