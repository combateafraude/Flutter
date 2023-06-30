import Flutter
import UIKit
import FaceAuthenticatorIproov

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
        
        let peopleId = arguments["personId"] as? String ?? ""
        
        let stage = getStageByString(stage: arguments["stage"] as! String)
        
        var faceAuthenticatorBuilder = FaceAuthSDK.Builder()
            .setCredentials(token: mobileToken,
                            personId: peopleId)
            .setStage(stage: .DEV)
            .build()
        
        
        let controller = UIApplication.shared.keyWindow!.rootViewController
        
        faceAuthenticatorBuilder.startFaceAuthSDK(viewController: controller!)
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
    public func didFinishFaceAuth(with faceAuthenticatorResult: FaceAuthenticatorResult) {
        print(faceAuthenticatorResult)
    }
}
