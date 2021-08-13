import 'package:passive_face_liveness/ios/customization.dart';
import 'package:passive_face_liveness/ios/sensor_stability_settings.dart';

class PassiveFaceLivenessIosSettings {
  PassiveFaceLivenessCustomizationIos customization;
  int beforePictureMillis;
  SensorStabilitySettingsIos sensorStability;
  bool enableManualCapture;
  double timeEnableManualCapture;

  PassiveFaceLivenessIosSettings(
  {this.customization, this.beforePictureMillis, this.sensorStability, this.enableManualCapture, this.timeEnableManualCapture});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["beforePictureMillis"] = beforePictureMillis;
    map["sensorStability"] = sensorStability?.asMap();
    map["enableManualCapture"] = enableManualCapture;
    map["timeEnableManualCapture"] = timeEnableManualCapture;

    return map;
  }
}
