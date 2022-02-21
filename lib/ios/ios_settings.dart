import 'customization.dart';
import 'sensor_settings.dart';

class DocumentDetectorIosSettings {
  double detectionThreshold;
  bool verifyQuality;
  double qualityThreshold;
  DocumentDetectorCustomizationIos customization;
  SensorSettingsIos sensorSettings;
  bool enableManualCapture;
  double timeEnableManualCapture;
  String resolution;
  double compressQuality;

  DocumentDetectorIosSettings(
      {this.detectionThreshold,
      this.verifyQuality,
      this.qualityThreshold,
      this.customization,
      this.sensorSettings,
      this.enableManualCapture,
      this.timeEnableManualCapture,
      this.resolution,
      this.compressQuality});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["detectionThreshold"] = detectionThreshold;
    map["verifyQuality"] = verifyQuality;
    map["qualityThreshold"] = qualityThreshold;
    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["enableManualCapture"] = enableManualCapture;
    map["timeEnableManualCapture"] = timeEnableManualCapture;
    map["resolution"] = resolution;
    map["compressQuality"] = compressQuality;

    return map;
  }
}
