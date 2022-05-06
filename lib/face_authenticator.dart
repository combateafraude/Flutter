import 'dart:async';

import 'package:face_authenticator/android/image_capture.dart';
import 'package:face_authenticator/android/video_capture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'android/settings.dart';
import 'ios/settings.dart';
import 'result/face_authenticator_closed.dart';
import 'result/face_authenticator_failure.dart';
import 'result/face_authenticator_result.dart';
import 'result/face_authenticator_success.dart';

class FaceAuthenticator {
  static const MethodChannel _channel =
      const MethodChannel('face_authenticator');

  String mobileToken;
  String? peopleId;
  bool? useAnalytics;
  String? sound;
  bool? enableSound;
  int? requestTimeout;
  FaceAuthenticatorAndroidSettings? androidSettings;
  FaceAuthenticatorIosSettings? iosSettings;
  ImageCapture? imageCapture;
  VideoCapture? videoCapture;
  String? stage;

  FaceAuthenticator({required this.mobileToken});

  void setAudioSettings(bool enable, {String? soundResId}) {
    this.enableSound = enable;
    this.sound = soundResId;
  }

  void setCaptureMode(
      {VideoCapture? videoCapture, ImageCapture? imageCapture}) {
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

  void setAndroidSettings(FaceAuthenticatorAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(FaceAuthenticatorIosSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  void setStage(String stage) {
    this.stage = stage;
  }

  Future<FaceAuthenticatorResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["useAnalytics"] = useAnalytics;
    params["sound"] = sound;
    params["enableSound"] = enableSound;
    params["requestTimeout"] = requestTimeout;
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();
    params["imageCapture"] = imageCapture?.asMap();
    params["videoCapture"] = videoCapture?.asMap();
    params["stage"] = stage;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool? success = resultMap["success"];
    if (success == null) {
      return new FaceAuthenticatorClosed();
    } else if (success == true) {
      return new FaceAuthenticatorSuccess(resultMap["authenticated"],
          resultMap["signedResponse"], resultMap["trackingId"]);
    } else {
      return new FaceAuthenticatorFailure(
          resultMap["message"], resultMap["type"]);
    }
  }
}
