import Flutter
import UIKit
import FaceLiveness

public class SwiftPassiveFaceLivenessPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    var flutterResult: FlutterResult?
    var sink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "passive_face_liveness", binaryMessenger: registrar.messenger())
        let instance = SwiftPassiveFaceLivenessPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        FlutterEventChannel(name: "liveness_listener", binaryMessenger: registrar.messenger())
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

        let peopleId = arguments["personId"] as! String
        
        let mFaceLivenessBuilder = FaceLivenessSDK.Build()
            .setCredentials(mobileToken: mobileToken, personId: peopleId)
        
        // Stage
         if let stage = arguments["stage"] as? String ?? nil {
            mFaceLivenessBuilder.setStage(stage: getStageByString(stage: stage))
        }

        // Camera Filter
        if let filter = arguments["filter"] as? String ?? nil {
            mFaceLivenessBuilder.setFilter(filter: getFilterByString(filter: filter))
        }

        // Enable SDK default loading screen
        if let enableLoadingScreen = arguments["enableLoadingScreen"] as? Bool ?? nil {
            mFaceLivenessBuilder.setLoadingScreen(withLoading: enableLoadingScreen)
        }

        if let expirationTime = arguments["imageUrlExpirationTime"] as? String ?? nil {
            mFaceLivenessBuilder.setImageUrlExpirationTime(time: getExpirationTimeByString(time: expirationTime))
        }
        
        let controller = UIApplication.shared.keyWindow!.rootViewController

        // FaceLiveness Build
        let faceLiveness = mFaceLivenessBuilder.build()
        
        faceLiveness.delegate = self
        faceLiveness.startSDK(viewController: controller!)

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
        
    public func getStageByString(stage: String) -> CAFStage {
        if (stage == "BETA") {
            return .BETA
        } else if (stage == "DEV") {
            return .DEV
        } else {
            return .PROD
        }
    }

    public func getFilterByString(filter: String) -> Filter {
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

extension SwiftPassiveFaceLivenessPlugin: FaceLivenessDelegate {
    public func didFinishLiveness(with faceLivenesResult: FaceLivenessResult) {

        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "success")
        
        response["signedResponse"] = faceLivenesResult.signedResponse

        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithFail(with faceLivenessFailResult: FaceLiveness.FaceLivenessFailResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "failure")
        
        response["signedResponse"] = faceLivenessFailResult.signedResponse
        response["errorType"] = String(describing: faceLivenessFailResult.failType)
        response["errorMessage"] = faceLivenessFailResult.description
        response["code"] = faceLivenessFailResult.code

        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithCancelled(with faceLivenessResult: FaceLiveness.FaceLivenessResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "canceled")
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithError(with faceLivenessErrorResult: FaceLiveness.FaceLivenessErrorResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "error")
        
        response["errorType"] = String(describing: faceLivenessErrorResult.errorType)
        response["errorMessage"] = faceLivenessErrorResult.description
        response["code"] = faceLivenessErrorResult.code
        
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

