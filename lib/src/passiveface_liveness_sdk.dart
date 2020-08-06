part of passiveface_liveness_sdk;

class PassiveFaceLivenessSdk {
  static PassiveFaceLivenessSdk _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory PassiveFaceLivenessSdk() {
    if (_singleton == null) {
      _singleton = PassiveFaceLivenessSdk._();
    }
    return _singleton;
  }

  PassiveFaceLivenessSdk._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.passiveface_liveness_sdk/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
