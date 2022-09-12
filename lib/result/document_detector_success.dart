import 'package:document_detector_compatible/result/capture.dart';
import 'package:document_detector_compatible/result/document_detector_result.dart';

class DocumentDetectorSuccess extends DocumentDetectorResult {
  List<Capture> captures;
  String type;
  String trackingId;

  DocumentDetectorSuccess(this.captures, this.type, this.trackingId);
}
