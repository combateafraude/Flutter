import 'dart:async';

import 'package:document_detector/android/android_settings.dart';
import 'package:document_detector/document_detector_step.dart';
import 'package:document_detector/ios/ios_settings.dart';
import 'package:document_detector/preview_settings.dart';
import 'package:document_detector/result/capture.dart';
import 'package:document_detector/result/document_detector_closed.dart';
import 'package:document_detector/result/document_detector_failure.dart';
import 'package:document_detector/result/document_detector_result.dart';
import 'package:document_detector/result/document_detector_success.dart';
import 'package:document_detector/show_preview.dart';
import 'package:document_detector/message_settings.dart';
import 'package:document_detector/upload_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DocumentDetector {
  static const MethodChannel _channel =
      const MethodChannel('document_detector');

  String mobileToken;
  String? peopleId;
  bool? useAnalytics;
  late List<DocumentDetectorStep> documentDetectorSteps;
  bool? popup;
  bool? sound;
  int? requestTimeout;
  ShowPreview? showPreview;
  PreviewSettings? previewSettings;
  DocumentDetectorAndroidSettings? androidSettings;
  DocumentDetectorIosSettings? iosSettings;
  bool? showDelay;
  int? delay;
  bool? autoDetection;
  MessageSettings? messageSettings;
  String? expireTime;
  UploadSettings? uploadSettings;
  String? stage;

  DocumentDetector({required this.mobileToken});

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

  @Deprecated(
      "Use the .setPreviewSettings(PreviewSettings previewSettings) method.")
  void setShowPreview(ShowPreview showPreview) {
    this.showPreview = showPreview;
  }

  void setPreviewSettings(PreviewSettings previewSettings) {
    this.previewSettings = previewSettings;
  }

  void setAutoDetection(bool enable) {
    this.autoDetection = enable;
  }

  void setCurrentStepDoneDelay(bool showDelay, int delay) {
    this.showDelay = showDelay;
    this.delay = delay;
  }

  void setMessageSettings(MessageSettings messageSettings) {
    this.messageSettings = messageSettings;
  }

  void setAndroidSettings(DocumentDetectorAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(DocumentDetectorIosSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  void setGetImageUrlExpireTime(String expireTime) {
    this.expireTime = expireTime;
  }

  void setUploadSettings(UploadSettings settings) {
    this.uploadSettings = settings;
  }

  void setStage(String stage) {
    this.stage = stage;
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
    params["previewSettings"] = previewSettings?.asMap();
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();
    params["showDelay"] = showDelay;
    params["delay"] = delay;
    params["autoDetection"] = autoDetection;
    params["messageSettings"] = messageSettings?.asMap();
    params["expireTime"] = expireTime;
    params["uploadSettings"] = uploadSettings?.asMap();
    params["stage"] = stage;

    List<Map<String, dynamic>> stepsMap = [];
    for (var step in documentDetectorSteps) {
      stepsMap.add(step.asMap() as Map<String, dynamic>);
    }
    params["documentSteps"] = stepsMap;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool? success = resultMap["success"];
    if (success == null) {
      return new DocumentDetectorClosed();
    } else if (success == true) {
      List<dynamic> capturesRaw = resultMap["captures"];
      var captureList = <Capture>[];
      for (dynamic captureRaw in capturesRaw) {
        captureList.add(new Capture(
            captureRaw["imagePath"],
            captureRaw["imageUrl"],
            captureRaw["label"],
            captureRaw["quality"],
            captureRaw["lensFacing"]));
      }
      return new DocumentDetectorSuccess(
          captureList, resultMap["type"], resultMap["trackingId"]);
    } else {
      return new DocumentDetectorFailure(
          resultMap["message"], resultMap["type"], resultMap["code"]);
    }
  }
}
