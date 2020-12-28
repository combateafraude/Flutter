import 'package:passive_face_liveness/android/capture_settings.dart';
import 'package:passive_face_liveness/android/customization.dart';
import 'package:passive_face_liveness/android/sensor_settings.dart';

class PassiveFaceLivenessAndroidSettings {
  PassiveFaceLivenessCustomizationAndroid customization;
  CaptureAndroidSettings captureSettings;
  SensorSettingsAndroid sensorSettings;
  int showButtonTime;

  PassiveFaceLivenessAndroidSettings(param0,
      {this.customization,
      this.captureSettings,
      this.sensorSettings,
      this.showButtonTime});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["captureSettings"] = captureSettings?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["showButtonTime"] = showButtonTime;

    return map;
  }
}
