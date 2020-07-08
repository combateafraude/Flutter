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
        var showStepLabel : Bool = true;
        var showStatusLabel : Bool = true;
        var hasSound : Bool = true;
        var colorTheme = UIColor.init(hexString: "#4CD964")
        var showPopup : Bool = false;
        var upload : Bool = false;
        var imageQuality = 1.0
        
        let layout = DocumentDetectorLayout()
        
        self.flutterResult = result
        let args = call.arguments as! [String: Any?]
        let mobileToken = args["mobileToken"] as! String
        let documentType = args["documentType"] as! String
        
        if let argTimeout = args["requestTimeout"] as? Int {
            requestTimeout = argTimeout
        }
        
        if let argHasSound = args["hasSound"] as? Bool {
            hasSound = argHasSound
        }
        
        if let argShowStepLabel = args["showStepLabel"] as? Bool {
            showStepLabel = argShowStepLabel
        }
        
        if let argShowStatusLabel = args["ShowStatusLabel"] as? Bool {
            showStatusLabel = argShowStatusLabel
        }
        
        if let argShowPopup = args["showPopup"] as? Bool {
            showPopup = argShowPopup
        }

        if let argUpload = args["upload"] as? Bool {
            upload = argUpload
            if let argImageQuality = args["imageQuality"] as? Int {
                imageQuality = Double(argImageQuality / 100)
            }
        }
        
        if let argColorTheme = args["colorTheme"] as? String {
            colorTheme = UIColor.init(hexString: argColorTheme)
        }
        
        if let layoutData = args["layout"] as? [String: Any] {
            var greenMask : UIImage?
            var whiteMask : UIImage?
            var redMask : UIImage?
            var soundOn : UIImage?
            var soundOff : UIImage?
            
            if let closeImageName = layoutData["closeImageName"] as? String {
                if let image = UIImage(named: closeImageName) {
                    layout.closeImage = image
                }
            }
            
            if let greenMaskImageName = layoutData["greenMaskImageName"] as? String {
                if let image = UIImage(named: greenMaskImageName) {
                    greenMask = image
                }
            }
            
            if let whiteMaskImageName = layoutData["whiteMaskImageName"] as? String {
                if let image = UIImage(named: whiteMaskImageName) {
                    whiteMask = image
                }
            }
            
            if let redMaskImageName = layoutData["redMaskImageName"] as? String {
                if let image = UIImage(named: redMaskImageName) {
                    redMask = image
                }
            }
            
            if let soundOnImageName = layoutData["soundOnImageName"] as? String {
                if let image = UIImage(named: soundOnImageName) {
                    soundOn = image
                }
            }
            
            if let soundOffImageName = layoutData["soundOffImageName"] as? String {
                if let image = UIImage(named: soundOffImageName) {
                    soundOff = image
                }
            }
            
            layout.changeMaskImages(
                greenMask: greenMask,
                whiteMask: whiteMask,
                redMask: redMask)
            
            layout.changeSoundImages(soundOn: soundOn,
                                     soundOff: soundOff)
        }


        let documentDetectorConfiguration = DocumentDetectorBuilder(apiToken: mobileToken)
            .setDocumentDetectorFlow(flow: convertToDocumentFlow(documentType: documentType)!)
            .showPopup(show : showPopup)
            .setRequestTimeout(seconds: TimeInterval(requestTimeout))
            .setHasSound(hasSound: hasSound)
            .showStepLabel(show: showStepLabel)
            .showStatusLabel(show: showStatusLabel)
            .setColorTheme(color: colorTheme)
            .setLayout(layout: layout)
            .uploadImages(upload : upload, imageQuality : CGFloat(imageQuality))
            .build()
        
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        let scannerVC = DocumentDetectorController(documentDetectorConfiguration: documentDetectorConfiguration)
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

        response["captureFront_imagePath"] = captureFront_imagePath
        response["captureFront_imageUrl"] = results.captures[0].imageUrl
                response["captureFront_missedAttemps"] = results.captures[0].missedAttemps
        
        response["captureBack_imagePath"] = captureBack_imagePath
        response["captureBack_imageUrl"] = results.captures[1].imageUrl
        response["captureBack_missedAttemps"] = results.captures[1].missedAttemps
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

