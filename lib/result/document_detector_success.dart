import 'package:document_detector/result/capture.dart';
import 'package:document_detector/result/document_detector_result.dart';

class DocumentDetectorSuccess extends DocumentDetectorResult {

  List<Capture> captures;
  String type;

  DocumentDetectorSuccess(this.captures, this.type);
}