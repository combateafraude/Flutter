import 'package:document_detector/result/capture.dart';
import 'package:document_detector/result/document_detector_result.dart';

class DocumentDetectorSuccess extends DocumentDetectorResult {
  static int LENS_FACING_FRONT = 0;
  static int LENS_FACING_BACK = 1;
  List<Capture> captures;
  String? type;
  String? trackingId;

  DocumentDetectorSuccess(this.captures, this.type, this.trackingId);
}
