import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'face_liveness_method_channel.dart';

abstract class FaceLivenessPlatform extends PlatformInterface {
  /// Constructs a FaceLivenessPlatform.
  FaceLivenessPlatform() : super(token: _token);

  static final Object _token = Object();

  static FaceLivenessPlatform _instance = MethodChannelFaceLiveness();

  /// The default instance of [FaceLivenessPlatform] to use.
  ///
  /// Defaults to [MethodChannelFaceLiveness].
  static FaceLivenessPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FaceLivenessPlatform] when
  /// they register themselves.
  static set instance(FaceLivenessPlatform instance) {
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
