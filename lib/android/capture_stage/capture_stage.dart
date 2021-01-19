import 'package:document_detector_nodatabinding/android/capture_stage/capture_mode.dart';
import 'package:document_detector_nodatabinding/android/capture_stage/detection_settings.dart';
import 'package:document_detector_nodatabinding/android/capture_stage/quality_settings.dart';
import 'package:flutter/cupertino.dart';

class CaptureStage {
  int durationMillis;
  bool wantSensorCheck;
  QualitySettings qualitySettings;
  DetectionSettings detectionSettings;
  CaptureMode captureMode;

  CaptureStage(
      {this.durationMillis,
      @required this.wantSensorCheck,
      this.qualitySettings,
      this.detectionSettings,
      this.captureMode});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["durationMillis"] = durationMillis;
    map["wantSensorCheck"] = wantSensorCheck;
    map["qualitySettings"] = qualitySettings?.asMap();
    map["detectionSettings"] = detectionSettings?.asMap();
    map["captureMode"] = captureMode.toString().split(".")[1];

    return map;
  }
}
