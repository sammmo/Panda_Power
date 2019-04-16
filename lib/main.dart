import 'package:flutter/material.dart';
import 'package:panda_power/controllers/coordination_controller.dart';
import 'package:panda_power/controllers/motion_controller.dart';
import 'package:panda_power/enums.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  //CoordinationController coordinationController = new CoordinationController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Panda Power'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  //final CoordinationController coordinationController;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String activityState = '...Detecting State';
  double oneSecondAve = 0;
  double fiveSecondAve = 0;
  UserState userState = UserState.sedentary;
  UserState longTermState = UserState.sedentary;
  MotionController motionController = new MotionController();
  String reminder = '';

  @override
  initState() {
    super.initState();

    motionController.oneSecondAverage.addListener(oneSecListener);
    motionController.fiveSecondAverage.addListener(fiveSecListener);
    motionController.userState.addListener(stateListener);
    motionController.longTermState.addListener(longTermStateListener);
    motionController.reminder.addListener(reminderListener);
  }

  reminderListener() {
    setState(() {
      reminder = motionController.reminder.value.reminder;
    });
  }

  longTermStateListener() {
    setState(() {
      longTermState = motionController.longTermState.value;
    });
  }

  stateListener() {
    print("CHANGE STATE");
    setState(() {
      if (motionController.userState.value == UserState.sedentary) {
        activityState = 'INACTIVE';
      }

      if (motionController.userState.value == UserState.active) {
        activityState = 'ACTIVE';
      }
    });
  }

  fiveSecListener() {
    setState(() {
      fiveSecondAve = motionController.fiveSecondAverage.value;
    });
  }

  oneSecListener() {
    setState(() {
      oneSecondAve = motionController.oneSecondAverage.value;
    });
  }


  void changeUserState() {
    setState(() {
      //userState = widget.coordinationController.userState.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              reminder,
              style: TextStyle(
                fontSize: 250,
                color: Colors.green
              ),
            ),
            Text(
              '$longTermState',
              style: TextStyle(
                fontSize: 100,
                color: Colors.blue
              ),
            ),
            Text(
              activityState,
              style: TextStyle(
                fontSize: 60,
                color: Colors.red
              ),
            ),
            Text('Prior second average:'),
            Text(
              oneSecondAve.toString()
            ),
            Text('-----------------------------------'),
            Text('Prior five second average'),
            Text(
              fiveSecondAve.toString()
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
