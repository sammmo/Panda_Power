import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/widgets/loading_screen.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/new_game_menu.dart';
import 'package:panda_power/widgets/settings.dart';

const shadeAqua = const Color(0xFF75DBCD);
const shadeLtGreen = const Color(0xFFDEF4C6);
const shadeDarkBlue = const Color(0xFF1B512D);
const shadeGrey = const Color(0xFFCFCCD6);
const shadeMedGreen = const Color(0xFFB1CF5f);

final ThemeData _PowerUpPandaTheme = _buildPowerUpPandaTheme();

ThemeData _buildPowerUpPandaTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: shadeDarkBlue,
    primaryColor: shadeMedGreen,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: shadeAqua,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: shadeGrey,
    cardColor: shadeLtGreen,
    textSelectionColor: shadeMedGreen,
    errorColor: Colors.redAccent,
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final coordinationController = new CoordinationController();

  //CoordinationController coordinationController = new CoordinationController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder> {
      NewGameMenu.routeName: (BuildContext context) => new NewGameMenu(coordinationController),
      MainPage.routeName: (BuildContext context) => new MainPage(coordinationController, coordinationController.motionController.notifier),
      SettingsPage.routeName: (BuildContext context) => new SettingsPage(coordinationController, coordinationController.settings),
      LoadingScreen.routeName: (BuildContext context) => new LoadingScreen(coordinationController),
      //Message.routeName: (BuildContext context) => new Message(coordinationController.notifier),
    };
    return MaterialApp(
      title: 'Panda Power',
      theme: _PowerUpPandaTheme,
      home: new LoadingScreen(coordinationController),
      routes: routes,
    );
  }
}

class Message extends StatelessWidget {

  final coordinationController;
  static final String routeName = '/Message';

  Message(this.coordinationController);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.all(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Row(
            children: <Widget>[
              RaisedButton(),
              RaisedButton()
            ],
          ),
        ],
      ),
    );
  }

}