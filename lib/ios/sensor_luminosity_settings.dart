class SensorLuminositySettingsIos {
  String message;
  double luminosityThreshold;

  SensorLuminositySettingsIos(
  {this.message, this.luminosityThreshold});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["message"] = message;
    map["luminosityThreshold"] = luminosityThreshold;

    return map;
  }
}
