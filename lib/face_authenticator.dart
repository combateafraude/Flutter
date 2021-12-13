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
  String peopleId;
  bool useAnalytics;
  bool sound;
  int requestTimeout;
  FaceAuthenticatorAndroidSettings androidSettings;
  FaceAuthenticatorIosSettings iosSettings;
  ImageCapture imageCapture;
  VideoCapture videoCapture;

  FaceAuthenticator({@required this.mobileToken});

  void enableSound(bool enable) {
    this.sound = enable;
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

  void setAndroidSettings(FaceAuthenticatorAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(FaceAuthenticatorIosSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  Future<FaceAuthenticatorResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["useAnalytics"] = useAnalytics;
    params["sound"] = sound;
    params["requestTimeout"] = requestTimeout;
    params["androidSettings"] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();
    params["imageCapture"] = imageCapture?.asMap();
    params["videoCapture"] = videoCapture?.asMap();

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod('start', params);

    bool success = resultMap["success"];
    if (success == null) {
      return new FaceAuthenticatorClosed();
    } else if (success == true) {
      return new FaceAuthenticatorSuccess(resultMap["authenticated"],
          resultMap["signedResponse"], resultMap["trackingId"]);
    } else if (success == false) {
      return new FaceAuthenticatorFailure(
          resultMap["message"], resultMap["type"]);
    }
  }
}
