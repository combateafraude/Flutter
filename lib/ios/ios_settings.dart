
import 'customization.dart';
import 'sensor_settings.dart';

class DocumentDetectorIosSettings {
  double detectionThreshold;
  bool verifyQuality;
  double qualityThreshold;
  DocumentDetectorCustomizationIos customization;
  SensorSettingsIos sensorSettings;

  DocumentDetectorIosSettings(
      this.detectionThreshold,
      this.verifyQuality,
      this.qualityThreshold,
      this.customization,
      this.sensorSettings);

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["detectionThreshold"] = detectionThreshold;
    map["verifyQuality"] = verifyQuality;
    map["qualityThreshold"] = qualityThreshold;
    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();;

    return map;
  }
}
