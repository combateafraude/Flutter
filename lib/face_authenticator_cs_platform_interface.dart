import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'face_authenticator_cs_method_channel.dart';

abstract class FaceAuthenticatorCsPlatform extends PlatformInterface {
  /// Constructs a FaceAuthenticatorCsPlatform.
  FaceAuthenticatorCsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FaceAuthenticatorCsPlatform _instance =
      MethodChannelFaceAuthenticatorCs();

  /// The default instance of [FaceAuthenticatorCsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFaceAuthenticatorCs].
  static FaceAuthenticatorCsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FaceAuthenticatorCsPlatform] when
  /// they register themselves.
  static set instance(FaceAuthenticatorCsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> start(Map<String, dynamic> params) async {
    throw UnimplementedError(
        'start(Map<String, dynamic> params) has not been implemented.');
  }
}
