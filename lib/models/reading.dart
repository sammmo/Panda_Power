import 'dart:math';

class Reading {

  DateTime time;
  double vectorMag;

  Reading(double x, double y, double z, DateTime time) {

    this.time = time;

    this.vectorMag = calcVectorMag(x, y, z);
  }

  double calcVectorMag(double x, double y, double z) {

    double vm = sqrt(pow((x / 10), 2) + pow((y / 10), 2) + pow((z / 10), 2)) - 1;


    if (vm < 0) {
      vm = 0;
    }

    return vm * 1000;
  }
}