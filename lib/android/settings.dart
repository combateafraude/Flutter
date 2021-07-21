
import 'capture_settings.dart';
import 'customization.dart';
import 'sensor_settings.dart';

class FaceAuthenticatorAndroidSettings {

  FaceAuthenticatorCustomizationAndroid? customization;
  CaptureAndroidSettings? captureSettings;
  SensorSettingsAndroid? sensorSettings;

  FaceAuthenticatorAndroidSettings(
  {this.customization, this.captureSettings, this.sensorSettings});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["captureSettings"] = captureSettings?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();

    return map;
  }
}