import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'face_authenticator_cs_platform_interface.dart';

/// An implementation of [FaceAuthenticatorCsPlatform] that uses method channels.
class MethodChannelFaceAuthenticatorCs extends FaceAuthenticatorCsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('face_authenticator_cs');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<dynamic, dynamic>> start(Map<String, dynamic> params) async {
    return await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'start', params) as Map<dynamic, dynamic>;
  }
}
