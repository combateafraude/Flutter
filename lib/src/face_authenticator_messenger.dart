part of face_authenticator;

class FaceAuthenticatorMessenger {
  static FaceAuthenticatorMessenger _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory FaceAuthenticatorMessenger() {
    if (_singleton == null) {
      _singleton = FaceAuthenticatorMessenger._();
    }
    return _singleton;
  }

  FaceAuthenticatorMessenger._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.face_authenticator/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
