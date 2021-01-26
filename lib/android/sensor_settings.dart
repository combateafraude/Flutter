import 'package:passive_face_liveness_nodatabinding/android/sensor_stability_settings.dart';

class SensorSettingsAndroid {
  SensorStabilitySettingsAndroid sensorStabilitySettings;

  SensorSettingsAndroid({this.sensorStabilitySettings});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["sensorStabilitySettings"] = sensorStabilitySettings?.asMap();

    return map;
  }
}
