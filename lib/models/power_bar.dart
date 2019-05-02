import 'package:flutter/material.dart';

class PowerBar {
  var max;
  ValueNotifier<double> current = new ValueNotifier<double>(0.0);

  PowerBar(double maxAmt, double currentAmt) {
    this.max = maxAmt;
    this.current.value = currentAmt;
  }

  addToCurrent(double amt) {
    this.current.value += amt;
  }

  changeMax(double amt) {
    this.max = amt;
  }
}