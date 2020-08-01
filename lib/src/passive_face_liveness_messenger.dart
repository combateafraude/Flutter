part of passive_face_liveness;

class PassiveFaceLivenessMessenger {
  static PassiveFaceLivenessMessenger _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory PassiveFaceLivenessMessenger() {
    if (_singleton == null) {
      _singleton = PassiveFaceLivenessMessenger._();
    }
    return _singleton;
  }

  PassiveFaceLivenessMessenger._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.passive_face_liveness/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
