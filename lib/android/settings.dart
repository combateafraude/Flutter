import 'package:face_authenticator/android/image_capture.dart';
import 'package:face_authenticator/android/video_capture.dart';

import 'customization.dart';
import 'sensor_settings.dart';

class FaceAuthenticatorAndroidSettings {
  FaceAuthenticatorCustomizationAndroid customization;
  ImageCapture imageCapture;
  VideoCapture videoCapture;
  SensorSettingsAndroid sensorSettings;

  FaceAuthenticatorAndroidSettings(
      {this.customization,
      this.videoCapture,
      this.imageCapture,
      this.sensorSettings});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["customization"] = customization?.asMap();
    map["sensorSettings"] = sensorSettings?.asMap();
    map["imageCapture"] = imageCapture?.asMap();
    map["videoCapture"] = videoCapture?.asMap();

    return map;
  }
}
