import 'package:passive_face_liveness_nodatabinding/ios/customization.dart';
import 'package:passive_face_liveness_nodatabinding/ios/sensor_stability_settings.dart';

class PassiveFaceLivenessIosSettings {
  PassiveFaceLivenessCustomizationIos customization;
  int beforePictureMillis;
  SensorStabilitySettingsIos sensorStability;

  PassiveFaceLivenessIosSettings(
      {this.customization, this.beforePictureMillis, this.sensorStability});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["beforePictureMillis"] = beforePictureMillis;
    map["sensorStability"] = sensorStability?.asMap();

    return map;
  }
}
