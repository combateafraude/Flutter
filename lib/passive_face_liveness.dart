import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passive_face_liveness/android/settings.dart';
import 'package:passive_face_liveness/ios/settings.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_closed.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';
import 'package:passive_face_liveness/show_preview.dart';
import 'package:passive_face_liveness/message_settings.dart';


class PassiveFaceLiveness {
  static const MethodChannel _channel =
      const MethodChannel('passive_face_liveness');

  String mobileToken;
  String? peopleId;
  bool? useAnalytics;
  bool? sound;
  int? requestTimeout;
  ShowPreview? showPreview;
  PassiveFaceLivenessAndroidSettings? androidSettings;
  PassiveFaceLivenessIosSettings? iosSettings;
  bool? showDelay;
  int? delay;
  MessageSettings? messageSettings;

  PassiveFaceLiveness({required this.mobileToken});

  void enableSound(bool enable) {
    this.sound = enable;
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

  void setShowPreview(ShowPreview showPreview) {
    this.showPreview = showPreview;
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

  Future<PassiveFaceLivenessResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["useAnalytics"] = useAnalytics;
    params["sound"] = sound;
    params["requestTimeout"] = requestTimeout;
    params["showPreview"] = showPreview?.asMap();
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();
    params["showDelay"] = showDelay;
    params["delay"] = delay;
    params["messageSettings"] = messageSettings?.asMap();

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool? success = resultMap["success"];
    if (success == null) {
      return new PassiveFaceLivenessClosed();
    } else if (success == true) {
      return new PassiveFaceLivenessSuccess(
          resultMap["imagePath"],
          resultMap["imageUrl"],
          resultMap["signedResponse"],
          resultMap["trackingId"]);
    } else {
      return new PassiveFaceLivenessFailure(
          resultMap["message"], resultMap["type"]);
    }
  }
}
