import Flutter
import UIKit
import FaceAuthenticatorIproov

let MESSAGE_CHANNEL = "com.combateafraude.face_authenticator/message"
let ERROR_CODE = "FACE_AUTHENTICATOR_SDK_ERROR"

public class SwiftFaceAuthenticatorPlugin: NSObject, FlutterPlugin {

    var flutterResult: FlutterResult?

        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: "face_authenticator", binaryMessenger: registrar.messenger())
            let instance = SwiftFaceAuthenticatorPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }

        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            if call.method == "start" {
                flutterResult = result;
                start(call: call);
            } else {
                result(FlutterMethodNotImplemented);
            }
        }

        private func start(call: FlutterMethodCall) {

            let arguments = call.arguments as! [String: Any?]

            let mobileToken = arguments["mobileToken"] as! String

            let peopleId = arguments["peopleId"] as! String

            let stage = arguments["stage"] as? String

            var faceAuthenticatorBuilder = FaceAuthSDK.Builder()
                .setCredentials(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI2Mjg2YmU5Mzg2NDJmZDAwMDk4NWE1OWUiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.muHfkGn9ToDyt9cT_z6vHPNLH0GfDNJJ2WtnnsrqFpU", 
                                personId: "12597217604")
                .setStage(stage: getStageByString(stage: stage) ?? .PROD)
                .build()
            

            let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController

            faceAuthenticatorBuilder?.startFaceAuthSDK(viewController: controller)
        }

        public func getStageByString(stage: String) -> CAFStage {
            if(stage == "BETA"){
                return .BETA
            }else if(stage == "DEV"){
                return .DEV
            }else{
                return .PROD
            }
        }
    }

    extension SwiftFaceAuthenticatorPlugin: FaceAuthSDKDelegate {
    func didFinishFaceAuth(with faceAuthenticatorResult: FaceAuthenticatorResult) {
        print(faceAuthenticatorResult)
    }
}
