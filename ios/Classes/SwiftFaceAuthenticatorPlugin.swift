import Flutter
import UIKit
import FaceAuthenticator
import FaceLiveness

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
        
        let personId = arguments["personId"] as! String

        let mFaceAuthBuilder = FaceAuthSDK.Builder()
            .setCredentials(token: mobileToken, personId: personId)

        //Stage
        if let stage = arguments["stage"] as? String ?? nil {
            mFaceAuthBuilder.setStage(stage: getStageByString(stage: stage))
        }

        //Camera Filter
        if let filter = arguments["filter"] as? String ?? nil {
            mFaceAuthBuilder.setFilter(filter: getFilterByString(filter: filter))
        }
        
        //FaceAuthenticator Build
        
        let controller = UIApplication.shared.keyWindow!.rootViewController
        
        mFaceAuthBuilder.build().startFaceAuthSDK(viewController: controller!)
    }
    
    public func getStageByString(stage: String) -> FaceLiveness.CAFStage {
        if(stage == "BETA"){
            return .BETA
        }else if(stage == "DEV"){
            return .DEV
        }else{
            return .PROD
        }
    }
    
    public func getFilterByString(filter: String) -> FaceLiveness.Filter {
        if(filter == "NATURAL"){
            return .natural
        } else {
            return .lineDrawing
        }
        
    }
}

extension SwiftFaceAuthenticatorPlugin: FaceAuthSDKDelegate {
    public func didFinishFaceAuth(with faceAuthenticatorResult: FaceAuthenticatorResult) {
        let response : NSMutableDictionary! = [:]
        
        response["success"] = nil
        
        if faceAuthenticatorResult.errorMessage != nil {
            response["success"] = NSNumber(value: false)
            response["errorMessage"] = faceAuthenticatorResult.errorMessage
        }
        
        if faceAuthenticatorResult.signedResponse != nil {
            response["success"] = NSNumber(value: true)
            response["signedResponse"] = faceAuthenticatorResult.signedResponse
        }
        
        flutterResult!(response)
    }
}
