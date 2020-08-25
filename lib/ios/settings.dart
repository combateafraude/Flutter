import 'package:passive_face_liveness/ios/customization.dart';
import 'package:passive_face_liveness/ios/sensor_stability_settings.dart';

class PassiveFaceLivenessIosSettings {
  PassiveFaceLivenessCustomizationIos customization;
  int beforePictureMillis;
  SensorStabilitySettingsIos sensorStability;

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["beforePictureMillis"] = beforePictureMillis;
    map["sensorStability"] = sensorStability?.asMap();

    return map;
  }
}
