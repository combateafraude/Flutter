import 'package:document_detector_compatible/android/resolution.dart';

import 'capture_stage/capture_stage.dart';
import 'customization.dart';
import 'sensor_settings.dart';

class DocumentDetectorAndroidSettings {
  DocumentDetectorCustomizationAndroid customization;
  SensorSettingsAndroid sensorSettings;
  List<CaptureStage> captureStages;
  bool enableSwitchCameraButton;
  int compressQuality;
  String resolution;
  bool enableGoogleServices;
  bool enableEmulator;
  bool enableRootDevices;
  bool useDeveloperMode;
  bool useAdb;
  bool useDebug;

  DocumentDetectorAndroidSettings(
      {this.customization,
      this.sensorSettings,
      this.captureStages,
      this.enableSwitchCameraButton,
      this.compressQuality,
      this.resolution,
      this.enableGoogleServices,
      this.enableEmulator,
      this.enableRootDevices,
      this.useDeveloperMode,
      this.useAdb,
      this.useDebug});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["enableSwitchCameraButton"] = enableSwitchCameraButton;
    map["compressQuality"] = compressQuality;
    map["resolution"] = resolution;
    map["enableGoogleServices"] = enableGoogleServices;
    map["enableEmulator"] = enableEmulator;
    map["enableRootDevices"] = enableRootDevices;
    map["useDeveloperMode"] = useDeveloperMode;
    map["useAdb"] = useAdb;
    map["useDebug"] = useDebug;

    if (captureStages != null) {
      List<Map<String, dynamic>> stagesMap = [];
      for (var stage in captureStages) {
        stagesMap.add(stage?.asMap());
      }
      map["captureStages"] = stagesMap;
    }
    return map;
  }
}
