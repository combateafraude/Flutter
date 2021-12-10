class ImageCapture {
  bool use;
  int afterPictureMillis;
  int beforePictureMillis;

  ImageCapture({this.use, this.afterPictureMillis, this.beforePictureMillis});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["use"] = use;
    map["afterPictureMillis"] = afterPictureMillis;
    map["beforePictureMillis"] = beforePictureMillis;

    return map;
  }
}
