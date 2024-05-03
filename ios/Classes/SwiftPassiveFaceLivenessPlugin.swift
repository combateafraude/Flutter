import Flutter
import UIKit
import FaceLiveness

public class SwiftPassiveFaceLivenessPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    var flutterResult: FlutterResult?
    var sink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "face_liveness", binaryMessenger: registrar.messenger())
        let instance = SwiftPassiveFaceLivenessPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        FlutterEventChannel(name: "face_liveness_listener", binaryMessenger: registrar.messenger())
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
        
        let mFaceLivenessBuilder = FaceLivenessSDK.Build()
        
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
        faceLiveness.startSDK(viewController: controller!, mobileToken: mobileToken, personId: personId)

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
    
    public enum SdkEvent: String {
        case canceled = "canceled"
        case connected = "connected"
        case connecting = "connecting"
        case error = "error"
        case success = "success"
        case validated = "validated"
        case validating = "validating"
    }
    
}

extension SwiftPassiveFaceLivenessPlugin: FaceLivenessDelegate {
    public func didFinishLiveness(with livenessResult: LivenessResult) {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.success.rawValue
        
        response["signedResponse"] = livenessResult.signedResponse

        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithError(with sdkFailure: SDKFailure) {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.error.rawValue
        
        response["errorType"] = sdkFailure.errorType?.rawValue
        response["errorDescription"] = sdkFailure.description

        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func didFinishWithCancelled() {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.canceled.rawValue
        
        self.sink?(response)
        self.sink?(FlutterEndOfEventStream)
    }
    
    public func onConnectionChanged(_ state: LivenessState) {
    }
    
    public func openLoadingScreenStartSDK() {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.connecting.rawValue
        
        self.sink?(response)
    }
    
    public func closeLoadingScreenStartSDK() {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.connecting.rawValue
        
        self.sink?(response)
    }
    
    public func openLoadingScreenValidation() {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.validating.rawValue
        
        self.sink?(response)
    }
    
    public func closeLoadingScreenValidation() {
        let response : NSMutableDictionary! = [:]
        response["event"] = SdkEvent.validated.rawValue
        
        self.sink?(response)
    }
}

