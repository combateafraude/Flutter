import 'document_detector_result.dart';

class DocumentDetectorFailure extends DocumentDetectorResult {

  String message;
  String type;

  DocumentDetectorFailure(this.message, this.type);
}