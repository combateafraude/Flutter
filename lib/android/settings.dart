import 'customization.dart';
import 'sensor_settings.dart';

class FaceAuthenticatorAndroidSettings {
  FaceAuthenticatorCustomizationAndroid customization;

  SensorSettingsAndroid sensorSettings;

  bool enableEmulator;
  bool enableRootDevices;
  bool enableBrightnessIncrease;
  bool enableSwitchCameraButton;
  bool useDeveloperMode;
  bool useAdb;
  bool useDebug;

  FaceAuthenticatorAndroidSettings(
      {this.customization,
      this.sensorSettings,
      this.enableEmulator,
      this.enableRootDevices,
      this.enableBrightnessIncrease,
      this.enableSwitchCameraButton,
      this.useDeveloperMode,
      this.useAdb,
      this.useDebug});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["enableEmulator"] = enableEmulator;
    map["enableRootDevices"] = enableRootDevices;
    map["enableBrightnessIncrease"] = enableBrightnessIncrease;
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;
    map["useDeveloperMode"] = useDeveloperMode;
    map["useAdb"] = useAdb;
    map["useDebug"] = useDebug;

    return map;
  }
}
