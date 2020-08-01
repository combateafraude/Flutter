part of document_detector;

class DocumentDetectorMessenger {
  static DocumentDetectorMessenger _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory DocumentDetectorMessenger() {
    if (_singleton == null) {
      _singleton = DocumentDetectorMessenger._();
    }
    return _singleton;
  }

  DocumentDetectorMessenger._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.document_detector/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
