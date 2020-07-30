import Flutter
import UIKit
import FaceAuthenticator

let MESSAGE_CHANNEL = "com.combateafraude.face_authenticator/message"
let ERROR_CODE = "FACE_AUTHENTICATOR_SDK_ERROR"

public class SwiftFaceAuthenticatorPlugin: NSObject, FlutterPlugin, FaceAuthenticatorControllerDelegate {
    var methodChannel: FlutterMethodChannel?
    var flutterResult: FlutterResult?
    
    //---------------------------------------------------------------------------------------------
    // Plugin registry
    // --------------------------------------------------------------------------------------------
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MESSAGE_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftFaceAuthenticatorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    //---------------------------------------------------------------------------------------------
    // FlutterMethodChannel Interface Methods
    // --------------------------------------------------------------------------------------------
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "getDocuments":
            getDocuments(call: call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    // Combate a Fraude's Call Methods
    // --------------------------------------------------------------------------------------------
    private func getDocuments(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        var cpf = null
        var requestTimeout = 15
        var colorTheme = UIColor.init(hexString: "#4CD964")
        
        self.flutterResult = result
        let args = call.arguments as! [String: Any?]
        let mobileToken = args["mobileToken"] as! String
        
        
        if let argTimeout = args["requestTimeout"] as? Int {
            requestTimeout = argTimeout
        }
        
        if let argCpf = args["cpf"] as? String {
            cpf = argCpf
        }
        
        if let argColorTheme = args["colorTheme"] as? String {
            colorTheme = UIColor.init(hexString: argColorTheme)
        }
        
        let faceAuthenticatorConfiguration = FaceAuthenticatorBuilder(apiToken: mobileToken)
            .setCpf(cpf: cpf)
            .setRequestTimeout(seconds: TimeInterval(requestTimeout))
            .setColorTheme(color: colorTheme)
            .build()
        
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        let scannerVC = FaceAuthenticatorController(faceAuthenticatorConfiguration: faceAuthenticatorConfiguration)
        scannerVC.faceAuthenticatorDelegate = self
        controller.present(scannerVC, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------
    // Delegates
    // --------------------------------------------------------------------------------------------
    
    // MARK: - FaceAuthenticator Delegates
    public func faceAuthenticatorController(_ scanner: FaceAuthenticatorController, didFinishWithResults results: FaceAuthenticatorResult) {
        
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: true)
        response["authenticated"] = results.authenticated
        response["signedResponse"] = results.signedResponse
        flutterResult!(response)
    }
    
    public func faceAuthenticatorControllerDidCancel(_ scanner: FaceAuthenticatorController) {
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: false)
        response["cancel"] = NSNumber(value: true)
        flutterResult!(response)
    }
    
    public func faceAuthenticatorController(_ scanner: FaceAuthenticatorController, didFailWithError error: FaceAuthenticator.SDKFailure) {
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: false)
        if (error is InvalidTokenReason) {
            response["errorType"] = "InvalidTokenReason"
            response["errorMessage"] = error.message
        } else if ( error is NetworkReason) {
            response["errorType"] = "NetworkReason"
            response["errorMessage"] = error.message
        } else if ( error is ServerReason) {
            response["errorType"] = "ServerReason"
            response["errorCode"] = (error as! ServerReason).code
            response["errorMessage"] = error.message
        } else if ( error is StorageReason) {
            response["errorType"] = "StorageReason"
            response["errorMessage"] = error.message
        } else {
            response["errorType"] = "SDKFailure"
            response["errorMessage"] = error.message
        }
        flutterResult!(response)
    }
}

//---------------------------------------------------------------------------------------------
// Extension
// --------------------------------------------------------------------------------------------
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

