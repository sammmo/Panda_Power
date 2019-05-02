import 'package:flutter/material.dart';
import 'package:panda_power/widgets/loading_screen.dart';
import 'package:panda_power/widgets/utility_widgets.dart';

class SettingsPage extends StatefulWidget {

  final coordinationController;
  final settings;

  static const String routeName = '/SettingsPage';

  SettingsPage(this.coordinationController, this.settings);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  //TODO: implement user name change
  //TODO: decorate

  bool _switchValue;
  String userName;
  String pandaName;

  String notificationButton = 'Suspend notifications';
  bool notifications = true;

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
      widget.settings.userName = name;
    });
  }

  _changePandaName(String name) {

    setState(() {
      _pandaNameChangeIsVisible = false;
      widget.settings.pandaName = name;
      pandaName = name;
      _changePandaNameButtonIsVisible = true;
    });
  }

  _changeIsDemo(bool value) {

    widget.settings.isDemo = value;

    setState(() {
      _switchValue = value;
    });

  }

  _suspendNotifications() {
    if (notifications == true) {
      print('suspending');
      widget.coordinationController.suspendNotifications();
      notifications = false;
      setState(() {
        notificationButton = 'Resume notifications';
      });
    } else {
      print('resuming');
      widget.coordinationController.resumeNotifications();
      notifications = true;
      setState(() {
        notificationButton = 'Suspend notifications';
      });
    }
  }

  _resetGame() {
    print('reset game');
    widget.coordinationController.deleteGame();
    Navigator.pushReplacementNamed(context, LoadingScreen.routeName);
  }

  @override
  void initState() {
    super.initState();

    _switchValue = widget.settings.isDemo;
    userName = widget.settings.userName;
    pandaName = widget.settings.pandaName;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () => _suspendNotifications(),
                child: Text('$notificationButton'),
              ),
              Row(
                children: <Widget>[
                  Text('use demo settings'),
                  Switch(
                    value: _switchValue,
                    onChanged: (value) => _changeIsDemo(value),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () => _resetGame(),
                child: Text('reset'),
              ),
            ],
          )
        ),

    );

    /*
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[,
              Spacer(flex: 1,),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                FittedBox(
                fit: BoxFit.contain,
                  child: Text('Your panda\'s name is:',)
                ),
              ),
          ),
                  Text(
                      '$pandaName'
                  ),
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

                ],
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: null,
                    child: Text('Reset Game'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );*/
  }
}
