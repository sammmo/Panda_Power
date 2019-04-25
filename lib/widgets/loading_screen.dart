import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/main.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/new_game_menu.dart';

class LoadingScreen extends StatefulWidget {

  final coordinationController;

  LoadingScreen(this.coordinationController, {Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();

}

class _LoadingScreenState extends State<LoadingScreen>{

  var _showResume = false;
  var _showAdopt = false;
  var _showSettings = false;
  var _showLoadingMessage = true;

  @override
  initState()  {
    super.initState();
    
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showLoadingMessage = false;
      });
      _loadStateInController();
    });
  }

  _loadStateInController() async {
    var result = await widget.coordinationController.loadState();
    print(result);

    if (result == GameStatus.isNewGame) {
      print("I THINK THIS IS A NEW GAME");
      setState(() {
        _showAdopt = true;
        //_showSettings = true;
      });
    }

    if (result == GameStatus.isOldGame) {
      print("THIS IS AN OLD GAME");
      setState(() {
        _showResume = true;
        _showSettings = true;
      });
    }
    //return Future.value(result);
  }

  onButtonPress() {
    if (widget.coordinationController.isNewGame != null) {
      if (widget.coordinationController.isNewGame) {
        //Navigator.pushReplacementNamed(context, NewGameMenu.routeName);
      } else {
        print('loaded game');
        //Navigator.pushReplacementNamed(context, MainPage.routeName);
      }
    } else {
      //do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: (
            Center(
                child: Column(
                  children: <Widget>[
                    Spacer(flex: 1,),
                    Visibility(
                      visible: _showLoadingMessage,
                      child: Text('Loading Panda Power'),
                    ),
                    Visibility(
                      visible: _showResume,
                      child: RaisedButton(
                        child: Text('Resume Game'),
                        onPressed: () => Navigator.pushNamed(context, MainPage.routeName),
                      ),
                    ),
                    Visibility(
                      visible: _showAdopt,
                      child: RaisedButton(
                        child: Text('Adopt a Panda'),
                        onPressed: () => Navigator.pushNamed(context, NewGameMenu.routeName),
                      ),
                    ),
                    Visibility(
                      visible: _showSettings,
                      child: RaisedButton(
                        child: Text('Settings'),
                        onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
                      ),
                    ),
                    Spacer(flex: 1,),
                  ],
                )
            )
        )
    );
  }
}