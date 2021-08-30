import 'capture_stage/capture_stage.dart';
import 'customization.dart';
import 'sensor_settings.dart';

class DocumentDetectorAndroidSettings {
  DocumentDetectorCustomizationAndroid customization;
  SensorSettingsAndroid sensorSettings;
  List<CaptureStage> captureStages;
  bool enableSwitchCameraButton;

  DocumentDetectorAndroidSettings(
      {this.customization,
      this.sensorSettings,
      this.captureStages,
      this.enableSwitchCameraButton});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;

    if (captureStages != null) {
      List<Map<String, dynamic>> stagesMap = [];
      for (var stage in captureStages) {
        stagesMap.add(stage.asMap());
      }
      map["captureStages"] = stagesMap;
    }
    return map;
  }
}
