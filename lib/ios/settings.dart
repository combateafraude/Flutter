import 'customization.dart';
import 'sensor_stability_settings.dart';

class FaceAuthenticatorIosSettings {
  FaceAuthenticatorCustomizationIos customization;
  int beforePictureMillis;
  SensorStabilitySettingsIos sensorStability;
  bool enableManualCapture;
  double manualCaptureTime;

  FaceAuthenticatorIosSettings(
  {this.customization, this.beforePictureMillis, this.sensorStability, this.enableManualCapture, this.manualCaptureTime});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["beforePictureMillis"] = beforePictureMillis;
    map["sensorStability"] = sensorStability?.asMap();
    map["enableManualCapture"] = enableManualCapture;
    map["manualCaptureTime"] = manualCaptureTime;

    return map;
  }
}
