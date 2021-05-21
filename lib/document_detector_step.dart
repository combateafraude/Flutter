import 'package:flutter/foundation.dart';

import 'android/step_customization.dart';
import 'document_type.dart';
import 'ios/step_customization.dart';

class DocumentDetectorStep {
  DocumentType document;
  DocumentDetectorStepCustomizationAndroid? android;
  DocumentDetectorStepCustomizationIos? ios;

  DocumentDetectorStep({required this.document, this.android, this.ios});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["document"] = document.toString().split(".")[1];
    map["android"] = android?.asMap();
    map["ios"] = ios?.asMap();

    return map;
  }
}
