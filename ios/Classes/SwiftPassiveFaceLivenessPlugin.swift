import Flutter
import UIKit
import PassiveFaceLiveness

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

        let peopleId = arguments["peopleId"] as! String 
        
        var faceLiveness = FaceAuthSDK.FaceLivenessSDK.Build()
            .setCredentials(mobileToken: mobileToken, personId: peopleId)
            if let stage = arguments["stage"] as? String ?? nil {
                faceLiveness.setStage(stage: getStageByString(stage: stage))
            }
            .build()
        
        faceLiveness?.delegate = self
        
        
        faceLiveness.startSDK(viewController: self)
    }
        
    public func getStageByString(stage: String) -> CAFStage {
        if(stage == "BETA"){
            return .BETA
        }else{
            return .PROD
        }
    }
    
}

extension ViewController: FaceLivenessDelegate {
    func didFinishLiveness(with faceLivenesResult: FaceLivenessIproov.FaceLivenessResult) {

        let response : NSMutableDictionary! = [:]

        if faceLivenesResult.errorMessage != nil {
            response["success"] = NSNumber(value: false)
            response["isAlive"] = faceLivenesResult.isAlive
            response["errorMessage"] = faceLivenesResult.errorMessage
        } else {
            response["success"] = NSNumber(value: true)
            response["imageUrl"] = faceLivenesResult.imageUrl
            response["isAlive"] = faceLivenesResult.isAlive
            response["token"] = faceLivenesResult.token
        }

        flutterResult!(response)
    }
    
    func startLoadingScreen() {
        print("StartLoadScreen")
    }
    
}

