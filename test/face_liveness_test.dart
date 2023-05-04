import 'package:flutter_test/flutter_test.dart';
import 'package:face_liveness/face_liveness.dart';
import 'package:face_liveness/face_liveness_platform_interface.dart';
import 'package:face_liveness/face_liveness_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFaceLivenessPlatform
    with MockPlatformInterfaceMixin
    implements FaceLivenessPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FaceLivenessPlatform initialPlatform = FaceLivenessPlatform.instance;

  test('$MethodChannelFaceLiveness is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFaceLiveness>());
  });

  test('getPlatformVersion', () async {
    FaceLiveness faceLivenessPlugin = FaceLiveness();
    MockFaceLivenessPlatform fakePlatform = MockFaceLivenessPlatform();
    FaceLivenessPlatform.instance = fakePlatform;

    expect(await faceLivenessPlugin.getPlatformVersion(), '42');
  });
}
