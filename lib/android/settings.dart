import 'customization.dart';
import 'sensor_settings.dart';

class FaceAuthenticatorAndroidSettings {
  FaceAuthenticatorCustomizationAndroid customization;

  SensorSettingsAndroid sensorSettings;

  bool enableEmulator;
  bool enableRootDevices;

  FaceAuthenticatorAndroidSettings({this.customization, this.sensorSettings, this.enableEmulator, this.enableRootDevices});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["enableEmulator"] = enableEmulator;
    map["enableRootDevices"] = enableRootDevices;

    return map;
  }
}
