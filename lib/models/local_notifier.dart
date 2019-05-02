import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifier {

  FlutterLocalNotificationsPlugin localNotifications;
  StreamController<Widget> messages = new StreamController<Widget>.broadcast();
  bool messageIsActive = false;
  String pandaName = 'Panda';
  String userName = 'User';

  LocalNotifier() {
    setUpLocalNotifications();
  }

  sendMessage(Widget message) => this.messages.add(message);

  moveMessage() {
    if (messageIsActive == false) {
      messageIsActive = true;
      sendNote();
      messages.add(MoveCard('Message from $pandaName', 'Hey, $userName! We\'ve been resting for a while now! \n\nMind if we stretch our legs a bit?', this));
    }
  }

  activityMessage(int mins) {
    if (messageIsActive == false) {
      sendNote();
      messageIsActive = true;
      messages.add(MoveCard('Message from $pandaName',
        'That was great exercise! \nWe added $mins mins to our Power Bar!',
        this
      ));
    }
  }

  setUpLocalNotifications() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    localNotifications = new FlutterLocalNotificationsPlugin();

    localNotifications.initialize(initializationSettings);
  }

  Future<void> sendNote() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.show(
        0, 'Panda Power Up', '$pandaName has a message for you', platformChannelSpecifics,
        payload: 'item id 2');
  }
}

class MoveCard extends StatelessWidget {
  final String title;
  final String message;
  final LocalNotifier notifier;

  MoveCard(this.title, this.message, this.notifier);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 100,
              right: 8,
              left: 8,
              child: Image.asset('assets/images/messagePanda.png'),
            ),

            Positioned(top: 225, left: 8, right: 8,
                child: Card(
                  color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              '$title',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(35),
                          child: Center(
                            child: Text(
                                '$message',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              notifier.messageIsActive = false;
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        )
                      ],
                    ),
                ),
            ),
          ],
        );
  }
}