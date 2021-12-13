import 'customization.dart';
import 'sensor_settings.dart';

class FaceAuthenticatorAndroidSettings {
  FaceAuthenticatorCustomizationAndroid customization;

  SensorSettingsAndroid sensorSettings;

  FaceAuthenticatorAndroidSettings({this.customization, this.sensorSettings});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();

    return map;
  }
}
