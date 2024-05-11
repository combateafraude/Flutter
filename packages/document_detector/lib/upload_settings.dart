import 'package:document_detector/file_format.dart';
import 'package:flutter/cupertino.dart';

class UploadSettings {
  String? activityLayout;
  String? popUpLayout;
  bool? compress;
  List<String>? fileFormats;
  int? maxFileSize;
  String? intent;

  UploadSettings(
      {this.activityLayout,
      this.popUpLayout,
      this.compress,
      this.maxFileSize,
      this.intent,
      this.fileFormats});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["activityLayout"] = activityLayout;
    map["popUpLayout"] = popUpLayout;
    map["compress"] = compress;
    map["fileFormats"] = fileFormats;
    map["maxFileSize"] = maxFileSize;
    map["intent"] = intent;

    return map;
  }
}
