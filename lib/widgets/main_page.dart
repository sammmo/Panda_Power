import 'package:flutter/material.dart';
import 'package:panda_power/widgets/loading_screen.dart';
import 'package:panda_power/widgets/panda_head.dart';
import 'package:panda_power/widgets/power_bar.dart';
import 'package:panda_power/widgets/settings.dart';
import 'loading_screen.dart';

class MainPage extends StatefulWidget {

  final coordinationController;
  final notifier;

  static String routeName = '/MainPage';

  const MainPage(this.coordinationController, this.notifier, {Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var userName;
  var pandaName;



  @override
  void initState() {
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

    widget.coordinationController.startMotionSensing();
    widget.notifier.messages.stream.listen((message) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return message;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Power Up Panda!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
          ),
        ],
      ),
      body: Center(

        child: Stack(
          children: <Widget>[

        Column(
        children: <Widget>[
            Spacer(flex: 1),
        Expanded(
          flex: 4,
          child: PandaHead(
              coordinationController: widget.coordinationController
          ),
        ),
        Expanded(
          flex: 3,
          child: PowerBar(widget.coordinationController.powerBar),
        ),


        Text('Panda name: $pandaName'),
        Text('User name: $userName'),
        Spacer(flex: 1),
          BambooForest(),
        ],
      ),
          ],
        )

      )
    );
  }
}

