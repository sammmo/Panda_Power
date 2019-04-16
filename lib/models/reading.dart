import 'dart:math';

class Reading {

  //double x;
 // double y;
  //double z;
  DateTime time;
  double vectorMag;

  Reading(double x, double y, double z, DateTime time) {
    //this.x = x;
    //this.y = y;
    //this.z = z;
    this.time = time;

    this.vectorMag = calcVectorMag(x, y, z);
  }

  double calcVectorMag(double x, double y, double z) {
    //var xTimesTwo = sqrt(x.abs());
    //var yTimesTwo = sqrt(y.abs());
    //var zTimesTwo = sqrt(z.abs());

    //print(xTimesTwo.toString() + " " + yTimesTwo.toString() + " " + zTimesTwo.toString());

    //var squareThis = xTimesTwo + yTimesTwo + zTimesTwo;

    //print("squarethis " + squareThis.toString());

    double vm = sqrt(pow((x / 10), 2) + pow((y / 10), 2) + pow((z / 10), 2)) - 1;


    if (vm < 0) {
      vm = 0;
    }


    //print(vm.toString() + "mg");

    return vm * 1000;
  }

  //TODO: any processing functions
}