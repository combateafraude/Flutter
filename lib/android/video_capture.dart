import 'dart:ffi';

class VideoCapture {
  bool? use;
  int? time;

  VideoCapture({this.use, this.time});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["use"] = use;
    map["time"] = time;

    return map;
  }
}
