import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/widgets/loading_screen.dart';
import 'package:panda_power/widgets/main_page.dart';
import 'package:panda_power/widgets/new_game_menu.dart';
import 'package:panda_power/widgets/settings.dart';

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