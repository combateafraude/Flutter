import 'customization.dart';
import 'sensor_stability_settings.dart';

class FaceAuthenticatorIosSettings {
  FaceAuthenticatorCustomizationIos customization;
  int beforePictureMillis;
  SensorStabilitySettingsIos sensorStability;

  FaceAuthenticatorIosSettings(
  {this.customization, this.beforePictureMillis, this.sensorStability});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["beforePictureMillis"] = beforePictureMillis;
    map["sensorStability"] = sensorStability?.asMap();

    return map;
  }
}
