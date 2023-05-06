import 'package:flutter_test/flutter_test.dart';
import 'package:face_authenticator_cs/face_authenticator_cs.dart';
import 'package:face_authenticator_cs/face_authenticator_cs_platform_interface.dart';
import 'package:face_authenticator_cs/face_authenticator_cs_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFaceAuthenticatorCsPlatform
    with MockPlatformInterfaceMixin
    implements FaceAuthenticatorCsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FaceAuthenticatorCsPlatform initialPlatform = FaceAuthenticatorCsPlatform.instance;

  test('$MethodChannelFaceAuthenticatorCs is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFaceAuthenticatorCs>());
  });

  test('getPlatformVersion', () async {
    FaceAuthenticatorCs faceAuthenticatorCsPlugin = FaceAuthenticatorCs();
    MockFaceAuthenticatorCsPlatform fakePlatform = MockFaceAuthenticatorCsPlatform();
    FaceAuthenticatorCsPlatform.instance = fakePlatform;

    expect(await faceAuthenticatorCsPlugin.getPlatformVersion(), '42');
  });
}
