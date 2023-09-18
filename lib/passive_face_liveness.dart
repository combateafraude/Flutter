import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_closed.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_failure.dart';

import 'package:new_face_liveness_compatible/result/passive_face_liveness_result.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_success.dart';

class PassiveFaceLiveness {
  static const MethodChannel _channel =
      const MethodChannel('passive_face_liveness');

  String mobileToken;
  String peopleId;

  String stage;
  String filter;
  bool enableScreenshot;

  PassiveFaceLiveness({@required this.mobileToken, @required this.peopleId});

  void setStage(String stage) {
    this.stage = stage;
  }

  void setCameraFilter(String filter) {
    this.filter = filter;
  }

  /// This feature works only for Android right now
  void setEnableScreenshots(bool enable) {
    this.enableScreenshot = enable;
  }

  Future<PassiveFaceLivenessResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["personId"] = peopleId;
    params["stage"] = stage;
    params["filter"] = filter;
    params["enableScreenshot"] = enableScreenshot;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params);

    String event = resultMap["event"];

    switch (event) {
      case 'success':
        return new PassiveFaceLivenessSuccess(
            signedResponse: resultMap["signedResponse"]);
      case 'failure':
        return new PassiveFaceLivenessFailure(
            signedResponse: resultMap["signedResponse"],
            errorType: resultMap["errorType"],
            errorMessage: resultMap["errorMessage"],
            code: resultMap["code"]);
      case 'error':
        return new PassiveFaceLivenessFailure(
            errorType: resultMap["errorType"],
            errorMessage: resultMap["errorMessage"],
            code: resultMap["code"]);
      case 'cancelled':
        return new PassiveFaceLivenessClosed();
      default:
        throw 'Something unexpected happened';
    }
  }
}
