import 'package:document_detector/android/sensor_luminosity_settings.dart';
import 'package:document_detector/android/sensor_orientation_settings.dart';
import 'package:document_detector/android/sensor_stability_settings.dart';

class SensorSettingsAndroid {
  SensorLuminositySettingsAndroid sensorLuminositySettings;
  SensorOrientationSettingsAndroid sensorOrientationSettings;
  SensorStabilitySettingsAndroid sensorStabilitySettings;

  SensorSettingsAndroid(
      this.sensorLuminositySettings,
      this.sensorOrientationSettings,
      this.sensorStabilitySettings);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["sensorLuminositySettings"] = sensorLuminositySettings?.asMap();
    map["sensorOrientationSettings"] = sensorOrientationSettings?.asMap();
    map["sensorStabilitySettings"] = sensorStabilitySettings?.asMap();

    return map;
  }
}
