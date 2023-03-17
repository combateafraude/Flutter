import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passive_face_liveness_compatible/android/image_capture.dart';
import 'package:passive_face_liveness_compatible/android/settings.dart';
import 'package:passive_face_liveness_compatible/android/video_capture.dart';
import 'package:passive_face_liveness_compatible/ios/settings.dart';
import 'package:passive_face_liveness_compatible/preview_settings.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_closed.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_success.dart';
import 'package:passive_face_liveness_compatible/show_preview.dart';
import 'package:passive_face_liveness_compatible/message_settings.dart';

class PassiveFaceLiveness {
  static const MethodChannel _channel =
      const MethodChannel('passive_face_liveness');

  String mobileToken;
  String peopleId;
  String personCPF;
  String personName;
  bool useAnalytics;
  String sound;
  bool enableSound;
  int requestTimeout;
  PreviewSettings previewSettings;
  ShowPreview showPreview;
  PassiveFaceLivenessAndroidSettings androidSettings;
  PassiveFaceLivenessIosSettings iosSettings;
  bool showDelay;
  int delay;
  MessageSettings messageSettings;
  ImageCapture imageCapture;
  VideoCapture videoCapture;
  String stage;
  String expireTime;

  PassiveFaceLiveness({@required this.mobileToken});

  void setAudioSettings(bool enable, String soundResId) {
    this.enableSound = enable;
    this.sound = soundResId;
  }

  void setCaptureMode({VideoCapture videoCapture, ImageCapture imageCapture}) {
    this.videoCapture = videoCapture;
    this.imageCapture = imageCapture;
  }

  void setPeopleId(String peopleId) {
    this.peopleId = peopleId;
  }

  void setAnalyticsSettings(bool useAnalytics) {
    this.useAnalytics = useAnalytics;
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

  void setMessageSettings(MessageSettings messageSettings) {
    this.messageSettings = messageSettings;
  }

  void setAndroidSettings(PassiveFaceLivenessAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(PassiveFaceLivenessIosSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  void setCurrentStepDoneDelay(bool showDelay, int delay) {
    this.showDelay = showDelay;
    this.delay = delay;
  }

  @Deprecated("Use the .setPeopleId(String peopleId) method")
  void setPersonCPF(String personCPF) {
    this.personCPF = personCPF;
  }

  void setPersonName(String personName) {
    this.personName = personName;
  }

  void setStage(String stage) {
    this.stage = stage;
  }

  void setGetImageUrlExpireTime(String expireTime) {
    this.expireTime = expireTime;
  }

  Future<PassiveFaceLivenessResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["personName"] = personName;
    params["personCPF"] = personCPF;
    params["useAnalytics"] = useAnalytics;
    params["sound"] = sound;
    params["enableSound"] = enableSound;
    params["requestTimeout"] = requestTimeout;
    params["showPreview"] = showPreview?.asMap();
    params["previewSettings"] = previewSettings?.asMap();
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();
    params["showDelay"] = showDelay;
    params["delay"] = delay;
    params["messageSettings"] = messageSettings?.asMap();
    params["imageCapture"] = imageCapture?.asMap();
    params["videoCapture"] = videoCapture?.asMap();
    params["stage"] = stage;
    params["expireTime"] = expireTime;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool success = resultMap["success"];
    if (success == null) {
      return new PassiveFaceLivenessClosed();
    } else if (success == true) {
      return new PassiveFaceLivenessSuccess(
          resultMap["imagePath"],
          resultMap["capturePath"],
          resultMap["imageUrl"],
          resultMap["signedResponse"],
          resultMap["trackingId"]);
    } else {
      return new PassiveFaceLivenessFailure(
          resultMap["message"], resultMap["type"], resultMap["code"]);
    }
  }
}
