import 'package:flutter/material.dart';

class PowerBar extends StatefulWidget {

  final powerBar;

  PowerBar(this.powerBar);

  @override
  _PowerBarState createState() => _PowerBarState();
}

class _PowerBarState extends State<PowerBar> {

  double fillAmount = 0.0;
  int currentFillLabel = 0;
  double totalFillLabel = 0;

  @override
  void initState() {
    super.initState();
    widget.powerBar.current.addListener(changeAmount);
    //currentFillLabel
    //totalFillLabel

    setState(() {
      fillAmount = widget.powerBar.current.value;
      currentFillLabel = widget.powerBar.current.value.toInt();
      totalFillLabel = widget.powerBar.max;
    });
  }

  changeAmount() {
    setState(() {
      fillAmount = widget.powerBar.current.value;
      currentFillLabel = (widget.powerBar.current.value * 100).toInt();
    });
  }

  changeGoalAmount() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //color: Colors.purple,
                ),
                child: LinearProgressIndicator(
                    value: fillAmount,
                    backgroundColor: Colors.amber[50],
                    valueColor: new AlwaysStoppedAnimation(Colors.amberAccent)
                ),
              )
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                        '$currentFillLabel / ' + totalFillLabel.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black38
                    )

                    )
                  ),
              ],
            ),
          ),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }


}