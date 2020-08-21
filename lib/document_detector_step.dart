import 'package:document_detector/android/document_detector_step_customization.dart';
import 'package:document_detector/ios/document_detector_step_customization.dart';
import 'package:flutter/foundation.dart';

import 'document_type.dart';

class DocumentDetectorStep {
  DocumentType document;
  DocumentDetectorStepCustomizationAndroid android;
  DocumentDetectorStepCustomizationIos ios;

  DocumentDetectorStep({@required this.document, this.android, this.ios});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["document"] = document.toString().split(".")[1];
    map["android"] = android?.asMap();
    map["ios"] = ios?.asMap();

    return map;
  }
}
