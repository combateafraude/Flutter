import 'package:document_detector/android/capture_stage/capture_stage.dart';
import 'package:document_detector/android/sensor_settings.dart';

import 'document_detector_customization.dart';

class DocumentDetectorAndroidSettings {
  DocumentDetectorCustomizationAndroid customization;
  SensorSettingsAndroid sensorSettings;
  List<CaptureStage> captureStages;

  DocumentDetectorAndroidSettings(this.customization,
      this.sensorSettings, this.captureStages);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();

    List<Map<String, dynamic>> stagesMap = [];
    for (var stage in captureStages) {
      stagesMap.add(stage.asMap());
    }
    map["captureStages"] = stagesMap;

    return map;
  }
}
