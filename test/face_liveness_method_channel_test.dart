import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:face_liveness/face_liveness_method_channel.dart';

void main() {
  MethodChannelFaceLiveness platform = MethodChannelFaceLiveness();
  const MethodChannel channel = MethodChannel('face_liveness');

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
