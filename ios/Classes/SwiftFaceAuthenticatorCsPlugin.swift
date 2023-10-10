import Flutter
import UIKit
import FaceAuthenticatorCs

let MESSAGE_CHANNEL = "com.combateafraude.face_authenticator/message"
let ERROR_CODE = "FACE_AUTHENTICATOR_SDK_ERROR"

public class SwiftFaceAuthenticatorPlugin: NSObject, FlutterPlugin {

    var flutterResult: FlutterResult?

        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: "face_authenticator_cs", binaryMessenger: registrar.messenger())
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

            let clientId = arguments["clientId"] as! String
            let clientSecret = arguments["clientSecret"] as! String
            let token = arguments["token"] as! String
            let personId = arguments["personId"] as! String


            let faceAuthSDK = FaceAuthSDK.Builder()
                .setCredentials(clientId: clientId, clientSecret: clientSecret, token: token, personId: personId)
            .build()
            
            faceAuthSDK.delegate = self
            
            let controller = UIApplication.shared.keyWindow!.rootViewController!
            
            faceAuthSDK.startFaceAuthSDK(viewController: controller)
            
        }
    }

    extension SwiftFaceAuthenticatorPlugin: FaceAuthSDKDelegate {
        public func didFinishFaceAuth(with faceAuthenticatorResult: FaceAuthenticatorResult) {
        let response : NSMutableDictionary! = [:]
            
            response["responseMessage"] = faceAuthenticatorResult.errorMessage
            response["isMatch"] = faceAuthenticatorResult.isMatch
            response["isAlive"] = faceAuthenticatorResult.isAlive
            response["sessionId"] = faceAuthenticatorResult.sessionID
            flutterResult!(response)
    }
}
