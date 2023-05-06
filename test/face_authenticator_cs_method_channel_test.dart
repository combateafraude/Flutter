import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:face_authenticator_cs/face_authenticator_cs_method_channel.dart';

void main() {
  MethodChannelFaceAuthenticatorCs platform = MethodChannelFaceAuthenticatorCs();
  const MethodChannel channel = MethodChannel('face_authenticator_cs');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
