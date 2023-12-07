import Flutter
import UIKit
import FaceAuthenticator
import FaceLiveness

public class SwiftFaceAuthenticatorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    var flutterResult: FlutterResult?
    var sink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "face_authenticator", binaryMessenger: registrar.messenger())
        let instance = SwiftFaceAuthenticatorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        FlutterEventChannel(name: "face_auth_listener", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "start" {
            flutterResult = result;
            do {
                start(call: call);
            }
            result(nil)
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
        
        // Enable SDK default loading screen
        if let enableLoadingScreen = arguments["enableLoadingScreen"] as? Bool ?? nil {
            mFaceAuthBuilder.setLoading(withLoading: enableLoadingScreen)
        }
        
        if let expirationTime = arguments["imageUrlExpirationTime"] as? String ?? nil {
            mFaceAuthBuilder.setImageUrlExpirationTime(time: getExpirationTimeByString(time: expirationTime))
        }

        let controller = UIApplication.shared.keyWindow!.rootViewController

        //FaceAuthenticator Build
        let faceAuth = mFaceAuthBuilder.build()
        
        faceAuth.delegate = self
        faceAuth.startFaceAuthSDK(viewController: controller!)
    }

    public func getExpirationTimeByString(time: String) -> Time {
        if time == "THIRTY_DAYS" {
            return .thirtyDays
        } else if time == "THREE_HOURS" {
            return .threeHours
        } else {
            return .thirtyMin
        }
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
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            sink = events
            
            return nil
        }
        
        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            sink = nil
            
            return nil
        }
    
}

extension SwiftFaceAuthenticatorPlugin: FaceAuthSDKDelegate {
    public func didFinishSuccess(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorResult) {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "success")
        
        response["signedResponse"] = faceAuthenticatorResult.signedResponse
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithFail(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorFailResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "failure")
        
        response["signedResponse"] = faceAuthenticatorResult.signedResponse
        response["errorType"] = String(describing: faceAuthenticatorResult.errorType)
        response["errorMessage"] = faceAuthenticatorResult.description
        response["code"] = faceAuthenticatorResult.code
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithCancell(with faceAuthenticatorResult: FaceAuthenticator.FaceAuthenticatorResult) {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "canceled")
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithError(with faceAuthenticatorErrorResult: FaceAuthenticator.FaceAuthenticatorErrorResult) {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "error")
        
        response["errorType"] = String(describing: faceAuthenticatorErrorResult.errorType)
        response["errorMessage"] = faceAuthenticatorErrorResult.description
        response["code"] = faceAuthenticatorErrorResult.code
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func openLoadingScreenStartSDK() {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "connecting")
                
        self.sink?(response)
    }
    
    public func closeLoadingScreenStartSDK() {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "connected")
                
        self.sink?(response)
    }
    
    public func openLoadingScreenValidation() {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "validating")
                
        self.sink?(response)
    }
    
    public func closeLoadingScreenValidation() {
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "validated")
                
        self.sink?(response)
    }
}