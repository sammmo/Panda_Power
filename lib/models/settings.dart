class Settings {

  int id;
  bool isDemo;
  String userName;//accessible by coordcontroller
  String pandaName; //accessible by coordcontroller
  DateTime startSleep;
  DateTime endSleep;

  Settings(this.id, this.isDemo, this.pandaName, this.userName);

  Map toMap() {

    var map = {
      'id': this.id,
      'isDemo': this.isDemo,
      'userName': this.userName,
      'pandaName': this.pandaName
    };

    return map;
  }

  /*static fromMap(Map map) {
    return new Settings(map['id'], map['isDemo'], map['userName'], map['pandaName']);
  }*/

}