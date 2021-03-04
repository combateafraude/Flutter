import 'dart:async';

import 'package:document_detector/android/android_settings.dart';
import 'package:document_detector/document_detector_step.dart';
import 'package:document_detector/ios/ios_settings.dart';
import 'package:document_detector/result/capture.dart';
import 'package:document_detector/result/document_detector_closed.dart';
import 'package:document_detector/result/document_detector_failure.dart';
import 'package:document_detector/result/document_detector_result.dart';
import 'package:document_detector/result/document_detector_success.dart';
import 'package:document_detector/show_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DocumentDetector {
  static const MethodChannel _channel =
      const MethodChannel('document_detector');

  String mobileToken;
  String peopleId;
  bool useAnalytics;
  List<DocumentDetectorStep> documentDetectorSteps;
  bool popup;
  bool sound;
  int requestTimeout;
  ShowPreview showPreview;
  DocumentDetectorAndroidSettings androidSettings;
  DocumentDetectorIosSettings iosSettings;

  DocumentDetector({@required this.mobileToken});

  void setDocumentFlow(List<DocumentDetectorStep> documentDetectorSteps) {
    this.documentDetectorSteps = documentDetectorSteps;
  }

  void setPeopleId(String peopleId) {
    this.peopleId = peopleId;
  }

  void setAnalyticsSettings(bool useAnalytics) {
    this.useAnalytics = useAnalytics;
  }

  void setPopupSettings(bool show) {
    this.popup = show;
  }

  void enableSound(bool enable) {
    this.sound = enable;
  }

  void setNetworkSettings(int requestTimeout) {
    this.requestTimeout = requestTimeout;
  }

  void setShowPreview(ShowPreview showPreview) {
    this.showPreview = showPreview;
  }

  void setAndroidSettings(DocumentDetectorAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(DocumentDetectorIosSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  Future<DocumentDetectorResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["useAnalytics"] = useAnalytics;
    params["popup"] = popup;
    params["sound"] = sound;
    params["requestTimeout"] = requestTimeout;
    params["showPreview"] = showPreview?.asMap();
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();

    List<Map<String, dynamic>> stepsMap = [];
    for (var step in documentDetectorSteps) {
      stepsMap.add(step.asMap());
    }
    params["documentSteps"] = stepsMap;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod('start', params);

    bool success = resultMap["success"];
    if (success == null) {
      return new DocumentDetectorClosed();
    } else if (success == true) {
      List<dynamic> capturesRaw = resultMap["captures"];
      List<Capture> captureList = new List();
      for (dynamic captureRaw in capturesRaw) {
        captureList.add(new Capture(
            captureRaw["imagePath"],
            captureRaw["imageUrl"],
            captureRaw["label"],
            captureRaw["quality"]));
      }
      return new DocumentDetectorSuccess(
          captureList, resultMap["type"], resultMap["trackingId"]);
    } else if (success == false) {
      return new DocumentDetectorFailure(
          resultMap["message"], resultMap["type"]);
    }
  }
}
