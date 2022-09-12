import 'package:passive_face_liveness_compatible/android/image_capture.dart';
import 'package:passive_face_liveness_compatible/android/customization.dart';
import 'package:passive_face_liveness_compatible/android/sensor_settings.dart';

class PassiveFaceLivenessAndroidSettings {
  PassiveFaceLivenessCustomizationAndroid customization;
  SensorSettingsAndroid sensorSettings;
  int showButtonTime;
  bool enableSwitchCameraButton;
  bool enableGoogleServices;
  bool emulatorSettings;
  bool rootSettings;
  bool enableBrightnessIncrease;
  bool useDeveloperMode;
  bool useAdb;
  bool useDebug;

  PassiveFaceLivenessAndroidSettings(
      {this.customization,
      this.sensorSettings,
      this.showButtonTime,
      this.enableSwitchCameraButton,
      this.enableGoogleServices,
      this.emulatorSettings,
      this.rootSettings,
      this.enableBrightnessIncrease,
      this.useDeveloperMode,
      this.useAdb,
      this.useDebug});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["showButtonTime"] = showButtonTime;
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;
    map["enableGoogleServices"] = enableGoogleServices;
    map["useEmulator"] = emulatorSettings;
    map["useRoot"] = rootSettings;
    map["enableBrightnessIncrease"] = enableBrightnessIncrease;
    map["useDeveloperMode"] = useDeveloperMode;
    map["useAdb"] = useAdb;
    map["useDebug"] = useDebug;

    return map;
  }
}
