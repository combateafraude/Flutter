import 'package:document_detector/ios/document_detector_customization.dart';
import 'package:document_detector/ios/sensor_luminosity_settings.dart';
import 'package:document_detector/ios/sensor_orientation_settings.dart';
import 'package:document_detector/ios/sensor_stability_settings.dart';

class DocumentDetectorIosSettings {

  double detectionThreshold;
  bool verifyQuality;
  double qualityThreshold;
  DocumentDetectorCustomizationIos customization;
  String colorHex;
  SensorLuminositySettingsIos sensorLuminosity;
  SensorOrientationSettingsIos sensorOrientation;
  SensorStabilitySettingsIos sensorStability;

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["detectionThreshold"] = detectionThreshold;
    map["verifyQuality"] = verifyQuality;
    map["qualityThreshold"] = qualityThreshold;
    map["customization"] = customization?.asMap();
    map["colorHex"] = colorHex;
    map["sensorLuminosity"] = sensorLuminosity?.asMap();
    map["sensorOrientation"] = sensorOrientation?.asMap();
    map["sensorStability"] = sensorStability?.asMap();

    return map;
  }

}
