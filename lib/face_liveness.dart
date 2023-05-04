import 'package:face_liveness/face_liveness_result.dart';
import 'package:flutter/services.dart';

import 'face_liveness_platform_interface.dart';

class FaceLiveness {
  late final String _clientId;
  late final String _clientSecret;
  late final String _token;
  late final String _personId;

  FaceLiveness(
      String clientId, String clientSecret, String token, String personId) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _token = token;
    _personId = personId;
  }

  Future<String?> getPlatformVersion() {
    return FaceLivenessPlatform.instance.getPlatformVersion();
  }

  Future<FaceLivenessResult> start() async {
    Map<String, dynamic> params = {};

    params["clientId"] = _clientId;
    params["clientSecret"] = _clientSecret;
    params["token"] = _token;
    params["personId"] = _personId;

    Map resultMap = await FaceLivenessPlatform.instance.start(params);

    return FaceLivenessResult(resultMap["responseMessage"], resultMap["image"],
        resultMap["sessionId"]);
  }
}
