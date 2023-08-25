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

        response["success"] = nil

        if faceLivenesResult.errorMessage != nil {
            response["success"] = NSNumber(value: false)
            response["errorMessage"] = faceLivenesResult.errorMessage
        }
        
        if faceLivenesResult.signedResponse != nil {
            response["success"] = NSNumber(value: true)
            response["signedResponse"] = faceLivenesResult.signedResponse
        }

        flutterResult!(response)
    }
}

