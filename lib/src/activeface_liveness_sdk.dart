part of activeface_liveness_sdk;

class ActivefaceLivenessSdk {
  static ActivefaceLivenessSdk _singleton;

  /// Constructs a singleton instance of [FlutterBranchSdk].
  factory ActivefaceLivenessSdk() {
    if (_singleton == null) {
      _singleton = ActivefaceLivenessSdk._();
    }
    return _singleton;
  }

  ActivefaceLivenessSdk._();

  static const _MESSAGE_CHANNEL =
      'com.combateafraude.activeface_liveness_sdk/message';
  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);
}
