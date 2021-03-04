import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passive_face_liveness/android/settings.dart';
import 'package:passive_face_liveness/ios/settings.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_closed.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';
import 'package:passive_face_liveness/show_preview.dart';

class PassiveFaceLiveness {
  static const MethodChannel _channel =
      const MethodChannel('passive_face_liveness');

  String mobileToken;
  String peopleId;
  bool useAnalytics;
  bool sound;
  int requestTimeout;
  ShowPreview showPreview;
  PassiveFaceLivenessAndroidSettings androidSettings;
  PassiveFaceLivenessIosSettings iosSettings;

  PassiveFaceLiveness({@required this.mobileToken});

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

  void setAndroidSettings(PassiveFaceLivenessAndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  void setIosSettings(PassiveFaceLivenessIosSettings iosSettings) {
    this.iosSettings = iosSettings;
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

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod('start', params);

    bool success = resultMap["success"];
    if (success == null) {
      return new PassiveFaceLivenessClosed();
    } else if (success == true) {
      return new PassiveFaceLivenessSuccess(
          resultMap["imagePath"],
          resultMap["imageUrl"],
          resultMap["signedResponse"],
          resultMap["trackingId"]);
    } else if (success == false) {
      return new PassiveFaceLivenessFailure(
          resultMap["message"], resultMap["type"]);
    }
  }
}
