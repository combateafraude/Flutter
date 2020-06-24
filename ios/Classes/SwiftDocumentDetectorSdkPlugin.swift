import Flutter
import UIKit
import TensorFlowLite
import DocumentDetector

let MESSAGE_CHANNEL = "com.combateafraude.document_detector_sdk/message"
let ERROR_CODE = "DOCUMENT_DETECTOR_SDK_ERROR"

public class SwiftDocumentDetectorSdkPlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {
    
    var methodChannel: FlutterMethodChannel?
    var flutterResult: FlutterResult?
    
    //---------------------------------------------------------------------------------------------
    // Plugin registry
    // --------------------------------------------------------------------------------------------
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MESSAGE_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftDocumentDetectorSdkPlugin()
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
    // Combate a Fraudes Call Methods
    // --------------------------------------------------------------------------------------------
    
    private func getDocuments(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        var requestTimeout = 15
        var colorTheme = UIColor.init(hexString: "#4CD964")
        
        self.flutterResult = result
        let args = call.arguments as! [String: Any?]
        let mobileToken = args["mobileToken"] as! String
        let documentType = args["documentType"] as! String
        
        if let argTimeout = args["requestTimeout"] as? Int {
            requestTimeout = argTimeout
        }
        
        if let argColorTheme = args["colorTheme"] as? String {
            colorTheme = UIColor.init(hexString: argColorTheme)
        }

        let documentDetectorConfiguration = DocumentDetectorBuilder(apiToken: mobileToken)
            .setDocumentDetectorFlow(flow: convertToDocumentFlow(documentType: documentType)!)
            .setRequestTimeout(seconds: TimeInterval(requestTimeout))
            .setColorTheme(color: colorTheme)
            .build()
        
        let scannerVC = DocumentDetectorController(documentDetectorConfiguration: documentDetectorConfiguration)
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        scannerVC.documentDetectorDelegate = self
        controller.present(scannerVC, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------
    // Delegates
    // --------------------------------------------------------------------------------------------
    
    public func documentDetectionController(_ scanner: DocumentDetectorController, didFinishWithResults results: DocumentDetectorResult) {
        
        let captureFront_imagePath = saveImageToDocumentsDirectory(image: results.captures[0].image, withName: "documentFront.jpg")
        let captureBack_imagePath = saveImageToDocumentsDirectory(image: results.captures[1].image, withName: "documentBack.jpg")
        
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: true)
        response["capture_type"] = results.type
        response["captureFront_missedAttemps"] = results.captures[0].missedAttemps
        response["captureFront_imagePath"] = captureFront_imagePath
        
        response["captureBack_missedAttemps"] = results.captures[1].missedAttemps
        response["captureBack_imagePath"] = captureBack_imagePath
        flutterResult!(response)
    }
    
    public func documentDetectionControllerDidCancel(_ scanner: DocumentDetectorController) {
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: false)
        response["cancel"] = NSNumber(value: true)
        flutterResult!(response)
    }
    
    public  func documentDetectionController(_ scanner: DocumentDetectorController, didFailWithError error:  DocumentDetector.SDKFailure) {
        
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
    
    //---------------------------------------------------------------------------------------------
    // Functions
    // --------------------------------------------------------------------------------------------
    
    func convertToDocumentFlow(documentType: String) -> [DocumentDetectorStep]? {
        switch documentType {
        case "RG":
            return DocumentDetectorBuilder.RG_FLOW;
        default:
            return DocumentDetectorBuilder.CNH_FLOW;
        }
    }
    
    func saveImageToDocumentsDirectory(image: UIImage, withName: String) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let dirPath = getDocumentsDirectory()
            let filename = dirPath.appendingPathComponent(withName)
            do {
                try data.write(to: filename)
                print("Successfully saved image at path: \(filename)")
                return filename.path
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
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

