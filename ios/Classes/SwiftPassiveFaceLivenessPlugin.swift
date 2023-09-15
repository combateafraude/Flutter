import Flutter
import UIKit
import FaceLiveness

public class SwiftPassiveFaceLivenessPlugin: NSObject, FlutterPlugin {
    
    var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "passive_face_liveness", binaryMessenger: registrar.messenger())
        let instance = SwiftPassiveFaceLivenessPlugin()
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

        let peopleId = arguments["personId"] as! String
        
        let mFaceLivenessBuilder = FaceLivenessSDK.Build()
            .setCredentials(mobileToken: mobileToken, personId: peopleId)
            .setLoadingScreen(withLoading: true)
        
        //Stage
         if let stage = arguments["stage"] as? String ?? nil {
            mFaceLivenessBuilder.setStage(stage: getStageByString(stage: stage))
        }

        //Camera Filter
        if let filter = arguments["filter"] as? String ?? nil {
            mFaceLivenessBuilder.setFilter(filter: getFilterByString(filter: filter))
        }
        
        let controller = UIApplication.shared.keyWindow!.rootViewController

        //FaceLiveness Build
        let faceLiveness = mFaceLivenessBuilder.build()
        
        faceLiveness.delegate = self
        faceLiveness.startSDK(viewController: controller!)

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
    
}

extension SwiftPassiveFaceLivenessPlugin: FaceLivenessDelegate {
    public func didFinishLiveness(with faceLivenesResult: FaceLivenessResult) {

        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "success")
        
        response["signedResponse"] = faceLivenesResult.signedResponse

        flutterResult!(response)
    }
    
    public func didFinishWithFail(with faceLivenessFailResult: FaceLiveness.FaceLivenessFailResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "failure")
        
        response["signedResponse"] = faceLivenessFailResult.signedResponse
        response["errorType"] = String(describing: faceLivenessFailResult.failType)
        response["errorMessage"] = faceLivenessFailResult.description
        response["code"] = faceLivenessFailResult.code

        flutterResult!(response)
    }
    
    public func didFinishWithCancelled(with faceLivenessResult: FaceLiveness.FaceLivenessResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "cancelled")
        
        flutterResult!(response)
    }
    
    public func didFinishWithError(with faceLivenessErrorResult: FaceLiveness.FaceLivenessErrorResult) {
        
        let response : NSMutableDictionary! = [:]
        response["event"] = NSString(string: "error")
        
        response["errorType"] = String(describing: faceLivenessErrorResult.errorType)
        response["errorMessage"] = faceLivenessErrorResult.description
        response["code"] = faceLivenessErrorResult.code
        
        flutterResult!(response)
    }
    
    //TODO: Figure out how to handle these events to Flutter side while SDK continues running
    public func openLoadingScreenStartSDK() {
    }
    
    public func closeLoadingScreenStartSDK() {
    }
    
    public func openLoadingScreenValidation() {
    }
    
    public func closeLoadingScreenValidation() {
    }
}

