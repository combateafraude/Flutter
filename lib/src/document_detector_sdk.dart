part of document_detector_sdk;

class DocumentDetectorSdk {
  static DocumentDetectorSdk _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory DocumentDetectorSdk() {
    if (_singleton == null) {
      _singleton = DocumentDetectorSdk._();
    }
    return _singleton;
  }

  DocumentDetectorSdk._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.document_detector_sdk/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
