import 'package:passive_face_liveness_nodatabinding/android/capture_settings.dart';
import 'package:passive_face_liveness_nodatabinding/android/customization.dart';
import 'package:passive_face_liveness_nodatabinding/android/sensor_settings.dart';

class PassiveFaceLivenessAndroidSettings {
  PassiveFaceLivenessCustomizationAndroid? customization;
  CaptureAndroidSettings? captureSettings;
  SensorSettingsAndroid? sensorSettings;
  int? showButtonTime;
  bool? enableSwitchCameraButton;
  bool? enableGoogleServices;

  PassiveFaceLivenessAndroidSettings(
      {this.customization,
      this.captureSettings,
      this.sensorSettings,
      this.showButtonTime,
      this.enableSwitchCameraButton,
      this.enableGoogleServices});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["captureSettings"] = captureSettings?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["showButtonTime"] = showButtonTime;
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;
    map["enableGoogleServices"] = enableGoogleServices;

    return map;
  }
}
