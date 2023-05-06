import Flutter
import UIKit

public class SwiftFaceAuthenticatorCsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "face_authenticator_cs", binaryMessenger: registrar.messenger())
    let instance = SwiftFaceAuthenticatorCsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
