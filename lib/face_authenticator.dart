import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'result/face_authenticator_closed.dart';
import 'result/face_authenticator_failure.dart';
import 'result/face_authenticator_result.dart';
import 'result/face_authenticator_success.dart';

class FaceAuthenticator {
  static const MethodChannel _channel =
      const MethodChannel('face_authenticator');

  String mobileToken;
  String personId;

  String stage;
  String filter;
  bool enableScreenshot;

  FaceAuthenticator({@required this.mobileToken, @required this.personId});

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

  Future<FaceAuthenticatorResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["personId"] = personId;
    params["stage"] = stage;
    params["filter"] = filter;
    params["enableScreenshot"] = enableScreenshot;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool success = resultMap["success"];
    if (success == null) {
      return new FaceAuthenticatorClosed();
    } else if (success == true) {
      return new FaceAuthenticatorSuccess(resultMap["signedResponse"]);
    } else {
      return new FaceAuthenticatorFailure(resultMap["errorMessage"]);
    }
  }
}
