import 'package:passive_face_liveness/android/capture_settings.dart';
import 'package:passive_face_liveness/android/customization.dart';
import 'package:passive_face_liveness/android/sensor_settings.dart';

class PassiveFaceLivenessAndroidSettings {
  PassiveFaceLivenessCustomizationAndroid? customization;
  CaptureAndroidSettings? captureSettings;
  SensorSettingsAndroid? sensorSettings;
  int? showButtonTime;
  bool? enableSwitchCameraButton;
  bool? enableGoogleServices;
  bool? emulatorSettings;
  bool? rootSettings;

  PassiveFaceLivenessAndroidSettings(
      {this.customization,
      this.captureSettings,
      this.sensorSettings,
      this.showButtonTime,
      this.enableSwitchCameraButton,
      this.enableGoogleServices,
      this.emulatorSettings,
      this.rootSettings});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["captureSettings"] = captureSettings?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["showButtonTime"] = showButtonTime;
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;
    map["enableGoogleServices"] = enableGoogleServices;
    map["useEmulator"] = emulatorSettings;
    map["useRoot"] = rootSettings;

    return map;
  }
}
