import 'package:flutter/material.dart';
import 'package:panda_power/widgets/utility.dart';

class SettingsPage extends StatefulWidget {

  final coordinationController;

  static const String routeName = '/SettingsPage';

  SettingsPage(this.coordinationController);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  //TODO: implement user name change
  //TODO: decorate

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