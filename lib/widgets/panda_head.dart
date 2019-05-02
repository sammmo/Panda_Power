import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panda_power/models/main_page.dart';

class PandaHead extends StatefulWidget {

  final coordinationController;

  PandaHead({this.coordinationController});

  @override
  _PandaHeadState createState() => new _PandaHeadState();
}

class _PandaHeadState extends State<PandaHead> {

  String eyeImageAsset = 'assets/images/eyesOpen.png';
  String mouthImageAsset = 'assets/images/closedMouth.png';
  Timer blinkTimer;

  @override
  void initState() {
    super.initState();

    if (widget.coordinationController != null) {
      _setPandaSleep();
      widget.coordinationController.pandaState.addListener(changeHeadState);
    } else {
      _setPandaBlink();
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (blinkTimer != null && blinkTimer.isActive) {
      blinkTimer.cancel();
    }
  }

  changeHeadState() {
    if (widget.coordinationController != null) {
      switch (widget.coordinationController.pandaState.value) {
        case PandaState.blink:
          _setPandaBlink();
          break;
        case PandaState.sleep:
          _setPandaSleep();
          break;
        case PandaState.exercise:
          _setPandaExercise();
          break;
        default:
          _setPandaBlink();
          break;
      }
    } else {
      _setPandaBlink();
    }

  }

  _setPandaExercise() {
    if (blinkTimer != null) {
      blinkTimer.cancel();
    }

    setState(() {
      eyeImageAsset = 'assets/images/exerciseEyes.png';
      mouthImageAsset = 'assets/images/exerciseMouth.png';
    });
  }

  _setPandaLaugh() {
    if (blinkTimer != null) {
      blinkTimer.cancel();
    }

    setState(() {
      eyeImageAsset = 'assets/images/eyesOpen.png';
      mouthImageAsset = 'assets/images/smilingMouth.png';
    });

    Future.delayed(Duration(seconds: 1)).then((_) {
      changeHeadState();
    });
  }

  _setPandaSleep() {
    if (blinkTimer != null && blinkTimer.isActive) {
      blinkTimer.cancel();
    }

    setState(() {
      eyeImageAsset = 'assets/images/blink.png';
      mouthImageAsset = 'assets/images/closedMouth.png';
    });
  }

  _setPandaBlink() {
    _blink();

    blinkTimer = new Timer.periodic(Duration(seconds: 5), (_) {
      _blink();
    });
  }

  _blink() {
    setState(() {
      eyeImageAsset = 'assets/images/blink.png';
    });

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      _open();
    });
  }

  _open() {
    setState(() {
      eyeImageAsset = 'assets/images/eyesOpen.png';
      mouthImageAsset = 'assets/images/closedMouth.png';
    });
  }
  //blink
  //wink
  //smile
  //blush
  //sleep
  //exercise

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        _setPandaLaugh();
      },
      child: Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                PandaBlankHead(),
                Container(
                  child: Image.asset(eyeImageAsset),
                ),
                Container(
                  child: Image.asset(mouthImageAsset),
                )
              ],
            ),
          )
      ),
    );
  }
}

class PandaBlankHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Image.asset('assets/images/pandaHeadBlank.png'),
    );
  }

}

class PandaEyes extends StatefulWidget {
  @override
  _PandaEyesState createState() => new _PandaEyesState();

}

class _PandaEyesState extends State<PandaEyes> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset('assets/images/eyesOpen.png');
  }
}