import Flutter
import UIKit
import FaceLivenessIproov

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
        
        var stageCaf = CAFStage.PROD
        if arguments["stage"] != nil {
            stageCaf = getStageByString(stage: arguments["stage"] as! String)
        }
        
        var faceLiveness = FaceLivenessSDK.Build()
            .setCredentials(mobileToken: mobileToken, personId: peopleId)
            .setStage(stage: .DEV)
            .build()
        
        faceLiveness.delegate = self
        
        let controller = UIApplication.shared.keyWindow!.rootViewController!
        
        faceLiveness.startSDK(viewController: controller)
    }
        
    public func getStageByString(stage: String) -> CAFStage {
        if(stage == "BETA"){
            return .BETA
        }else{
            return .PROD
        }
    }
    
}

extension SwiftPassiveFaceLivenessPlugin: FaceLivenessDelegate {
    public func didFinishLiveness(with faceLivenesResult: FaceLivenessIproov.FaceLivenessResult) {

        let response : NSMutableDictionary! = [:]

        if faceLivenesResult.errorMessage != nil {
            response["success"] = NSNumber(value: false)
            response["errorMessage"] = faceLivenesResult.errorMessage
        } else {
            response["success"] = NSNumber(value: true)
            response["signedResponse"] = faceLivenesResult.signedResponse
        }

        flutterResult!(response)
    }
    
    public func startLoadingScreen() {
        print("StartLoadScreen")
    }
    
}

