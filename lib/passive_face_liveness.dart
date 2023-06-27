import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_closed.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';


class PassiveFaceLiveness {
  static const MethodChannel _channel =
      const MethodChannel('passive_face_liveness');

  String mobileToken;
  String? peopleId;

  String? stage;

  PassiveFaceLiveness({required this.mobileToken});


  void setPeopleId(String peopleId) {
    this.peopleId = peopleId;
  }

  void setStage(String stage) {
    this.stage = stage;
  }

  Future<PassiveFaceLivenessResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["stage"] = stage;

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('start', params)
            as Map<dynamic, dynamic>;

    bool? success = resultMap["success"];
    if (success == null) {
      return new PassiveFaceLivenessClosed();
    } else if (success == true) {
      return new PassiveFaceLivenessSuccess(
          imageUrl: resultMap["imageUrl"],
          isAlive: resultMap["isAlive"],
          token: resultMap["token"]);
    } else {
      return new PassiveFaceLivenessFailure(
          resultMap["errorMessage"]);
    }
  }
}
