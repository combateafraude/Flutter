import 'dart:async';

import 'package:flutter/services.dart';
import 'package:new_face_liveness/face_liveness_events.dart';

const _LivenessMethodChannel = MethodChannel('passive_face_liveness');
const _LivenessListenerEventChannel = EventChannel('liveness_listener');

class FaceLiveness {
  String mobileToken;
  String personId;

  String? stage;
  String? filter;
  bool? enableScreenshot;
  bool? enableLoadingScreen;
  String? imageUrlExpirationTime;

  FaceLiveness({required this.mobileToken, required this.personId});

  /// Set the environment in wich the SDK will run.
  void setStage(String stage) {
    this.stage = stage;
  }

  /// Set the camera filter displayed to take the selfie picture
  void setCameraFilter(String filter) {
    this.filter = filter;
  }

  /// This feature works only for Android
  void setEnableScreenshots(bool enable) {
    this.enableScreenshot = enable;
  }

  /// Determines whether the loading screen will be the SDK default implementation or if you will implement your own.
  /// If set to 'true' the loading screen will be a standard SDK screen.
  /// In the case of 'false' you should implement the loading screen on your side.
  /// By default the loading screen is set to 'false'.
  void setEnableLoadingScreen(bool enable) {
    this.enableLoadingScreen = enable;
  }

  // Customize the image URL expiration time. You can set it to expire in 3h or 30 days.
  // Set the parameter with 'Time.threeHours' or 'Time.thirtyDays' to configure this.
  void setImageUrlExpirationTime(String time) {
    this.imageUrlExpirationTime = time;
  }

  Stream<FaceLivenessEvent> start() {
    Map<String, dynamic> params = new Map();

    params['mobileToken'] = mobileToken;
    params['personId'] = personId;
    params['stage'] = stage;
    params['filter'] = filter;
    params['enableScreenshot'] = enableScreenshot;
    params['enableLoadingScreen'] = enableLoadingScreen;
    params['imageUrlExpirationTime'] = imageUrlExpirationTime;

    _LivenessMethodChannel.invokeMethod('start', params);

    return _LivenessListenerEventChannel.receiveBroadcastStream()
        .map((result) => FaceLivenessEvent.fromMap(result));
  }
}
