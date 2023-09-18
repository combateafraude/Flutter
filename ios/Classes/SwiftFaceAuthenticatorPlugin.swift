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
            .setLoading(withLoading: true)

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
        
        let faceAuth = mFaceAuthBuilder.build()
        faceAuth.delegate = self
        
        faceAuth.startFaceAuthSDK(viewController: controller!)
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
    public func didFinishSuccess(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "success")
        
        response["signedResponse"] = faceAuthenticatorResult.signedResponse
        
        flutterResult!(response)
    }
    
    public func didFinishWithError(with faceAuthenticatorErrorResult: FaceAuthenticator.FaceAuthenticatorErrorResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "error")
        
        response["errorType"] = String(describing: faceAuthenticatorErrorResult.errorType)
        response["errorMessage"] = faceAuthenticatorErrorResult.description
        response["code"] = faceAuthenticatorErrorResult.code
        
        flutterResult!(response)
    }
    
    public func didFinishWithCancell(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorResult) {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "cancelled")
        
        flutterResult!(response)
    }
    
    public func didFinishWithFail(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorFailResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "failure")
        
        response["signedResponse"] = faceAuthenticatorResult.signedResponse
        response["errorType"] = String(describing: faceAuthenticatorResult.errorType)
        response["errorMessage"] = faceAuthenticatorResult.description
        response["code"] = faceAuthenticatorResult.code
        
        flutterResult!(response)
    }
    
    //TODO: Figure out how to send this events to Flutter side without stopping the SDK
    public func openLoadingScreenStartSDK() {
    }
    
    public func closeLoadingScreenStartSDK() {
    }
    
    public func openLoadingScreenValidation() {
    }
    
    public func closeLoadingScreenValidation() {
    }
}
