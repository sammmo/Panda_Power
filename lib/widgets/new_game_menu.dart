import 'package:flutter/material.dart';
import 'package:panda_power/widgets/main_page.dart';

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

  _changePandaName(String name) {
    setState(() {
      this.pandaName = name.trim();
      _changeMessage();

      if (this.userName != null && this.pandaName != null) {
        _showSaveButton = true;
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
            children: <Widget>[
              Spacer(flex: 1,),
              Text(message == null? '' : message),
              Row(
                children: <Widget>[
                  Text('Your Pandas Name: '),
                  //Text(pandaName == null? '' : pandaName),
                ],
              ),
              SizedBox(
                width: 250,
                child: TextEntryWidget(onChanged: (name) => _changePandaName(name), name: pandaName),
              ),
              Row(
                children: <Widget>[
                  Text('Your name: '),
                ],
              ),
              SizedBox(
                width: 250,
                child: TextEntryWidget(onChanged: (name) => _changeUserName(name), name: userName),
              ),
              Visibility(
                visible: _showSaveButton,
                child: RaisedButton(onPressed: _save,
                  child: Text('Start Game')),
              ),
              Spacer(flex: 1,),
            ],
          ),
        )
    ) ;
  }
}

class TextEntryWidget extends StatelessWidget {
  final onChanged;
  final name;

  const TextEntryWidget({Key key, this.onChanged, this.name}) : super(key: key);

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