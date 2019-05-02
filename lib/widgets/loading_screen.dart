import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/new_game_menu.dart';
import 'package:panda_power/widgets/panda_head.dart';
import 'package:panda_power/widgets/settings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {

  final coordinationController;

  static const String routeName = '/LoadingScreen';

  LoadingScreen(this.coordinationController, {Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();

}

class _LoadingScreenState extends State<LoadingScreen>{

  var _showResume = false;
  var _showAdopt = false;
  var _showLogo = true;

  @override
  initState() {
    super.initState();

    //TODO: change this to be delayed for however long it takes to
    //finish querying db
    
    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        _showLogo = false;
      });
      _loadControllerState();
    });
  }

  _loadControllerState() async {
    var result = await widget.coordinationController.loadState();
    print(result);

    if (result == GameStatus.isNewGame) {
      print("I THINK THIS IS A NEW GAME");
      setState(() {
        _showAdopt = true;
      });
    }

    if (result == GameStatus.isOldGame) {
      print("THIS IS AN OLD GAME");
      setState(() {
        _showResume = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: break this up to smaller stateful(visibility) widgets
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Expanded(
                child: PandaHead(),
                flex: 4
            ),
            Visibility(
              visible: _showLogo,
              child: Expanded(
                  child: Loading(),
              flex: 6,),
            ),
            Visibility(
              visible: _showResume,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed:() => Navigator.pushReplacementNamed(context, MainPage.routeName),
                          child: Text('Resume Game'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
                          child: Text('Settings'),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1
                    )
                  ],
                ),
                flex: 5,),
            ),
            Visibility(
              visible: _showAdopt,
              child: Spacer(
                flex: 1,
              )
            ),
            Visibility(
              visible: _showAdopt,
              child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, NewGameMenu.routeName),
                      child: Center(
                        child: Text(
                            'adopt a panda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                flex: 3,
              ),
            ),
            Visibility(
                visible: _showAdopt,
                child: Spacer(
                  flex: 1,
                )
            ),
            Expanded(
              child: BambooForest(),
              flex: 2
            )
          ],
        ),
      )
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 5,
          child: Logo(),
        ),
        Expanded (
          flex: 2,
          child: LoadingIndicator(),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }

}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SpinKitCircle(
      color: Theme.of(context).buttonColor,
      size: 50.0,
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Image.asset(
        'assets/images/logo.png',
      ),
    );
  }
  
}

class BambooForest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Image.asset('assets/images/bambooForrest.png'),
    );
  }

}