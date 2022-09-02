import 'document_detector_result.dart';

class DocumentDetectorFailure extends DocumentDetectorResult {
  String message;
  String type;
  int code;

  DocumentDetectorFailure(this.message, this.type, resultMap, this.code);
}
