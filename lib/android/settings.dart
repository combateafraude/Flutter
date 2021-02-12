import 'package:passive_face_liveness/android/capture_settings.dart';
import 'package:passive_face_liveness/android/customization.dart';
import 'package:passive_face_liveness/android/sensor_settings.dart';
import 'package:passive_face_liveness/android/show_preview.dart';

class PassiveFaceLivenessAndroidSettings {
  PassiveFaceLivenessCustomizationAndroid customization;
  CaptureAndroidSettings captureSettings;
  SensorSettingsAndroid sensorSettings;
  ShowPreview showPreview;
  int showButtonTime;

  PassiveFaceLivenessAndroidSettings(
      {this.customization,
      this.captureSettings,
      this.sensorSettings,
      this.showButtonTime,
      this.showPreview});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["captureSettings"] = captureSettings?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["showButtonTime"] = showButtonTime;
    map["showPreview"] = showPreview?.asMap();

    return map;
  }
}
