import 'package:flutter/material.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/panda_head.dart';

import 'loading_screen.dart';

class NewGameMenu extends StatefulWidget {

  final coordinationController;
  static const String routeName = '/NewGameMenu';

  NewGameMenu(this.coordinationController, {Key key}) : super(key: key);

  @override
  _NewGameMenuState createState() => _NewGameMenuState();
}

class _NewGameMenuState extends State<NewGameMenu> {
  String message;
  String pandaName;
  String userName;
  bool _showSaveButton = false;
  bool _showHead = true;

  _changePandaName(String name) {
    setState(() {
      this.pandaName = name.trim();
      _changeMessage();

      if (this.userName != null && this.pandaName != null) {
        _showSaveButton = true;
      }
    });
  }

  _hideFace() {
    print('face');
    setState(() {
      if (_showHead == true) {
        _showHead = false;
      } else {
        _showHead = true;
      }
    });
  }

  _changeUserName(String name) {
    setState(() {
      this.userName = name.trim();
      _changeMessage();
      if (this.userName != null && this.pandaName != null) {
        _showSaveButton = true;
      }
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
      if (this.userName != null && this.pandaName != null) {
        _showSaveButton = true;
      }
    });
  }

  @override
  initState() {

    super.initState();

    if (widget.coordinationController.settings.userName != null
    && widget.coordinationController.settings.userName != '') {
      userName = widget.coordinationController.settings.userName;
    }

    if (widget.coordinationController.settings.pandaName != null
        && widget.coordinationController.settings.pandaName != '') {
      userName = widget.coordinationController.settings.pandaName;
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
    widget.coordinationController.changeUserInfo(this.pandaName, this.userName);
    Navigator.popAndPushNamed(context, MainPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(flex: 1,),
              Expanded(
                flex: 4,
                child: PandaHead(),
              ),
              Spacer(flex: 1,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text('Your Panda\'s Name: '),
                      Expanded(
                        flex: 2,
                        child: TextEntryWidget(
                            onChanged: (name) => _changePandaName(name),
                            onTap: () => _hideFace(),
                            onDone: () => _hideFace(),
                            name: pandaName),
                      ),
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Text('Your Name: '),
                        Expanded(
                          flex: 2,
                          child: TextEntryWidget(onChanged: (name) => _changeUserName(name), name: userName),
                        ),
                      ],
                    )
                ),
              ),
              Visibility(
                visible: _showSaveButton,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(onPressed: _save,
                    child: Text('Start Game')),
                ),
              ),
              Spacer(flex: 1,),
              Expanded(
                flex: 2,
                child: BambooForest(),
              )
            ],
          ),
        )
    ) ;
  }
}

class TextEntryWidget extends StatelessWidget {
  final onChanged;
  final name;
  final onTap;
  final onDone;

  const TextEntryWidget({Key key, this.onChanged, this.name, this.onTap, this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(
        hintText: name,
      ),
      textCapitalization: TextCapitalization.words,
      //onSubmitted: this.onChanged,
      onChanged: this.onChanged,
    );
  }


}