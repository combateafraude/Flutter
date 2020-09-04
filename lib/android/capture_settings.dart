class CaptureAndroidSettings {
  int beforePictureMillis;
  int afterPictureMillis;

  CaptureAndroidSettings({this.beforePictureMillis, this.afterPictureMillis});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["beforePictureMillis"] = beforePictureMillis;
    map["afterPictureMillis"] = afterPictureMillis;

    return map;
  }
}