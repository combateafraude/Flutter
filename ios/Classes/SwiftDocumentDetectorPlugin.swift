import Flutter
import UIKit
import TensorFlowLite
import DocumentDetector

let MESSAGE_CHANNEL = "com.combateafraude.document_detector/message"
let ERROR_CODE = "DOCUMENT_DETECTOR_SDK_ERROR"

public class SwiftDocumentDetectorPlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {
    
    var methodChannel: FlutterMethodChannel?
    var flutterResult: FlutterResult?
    
    //---------------------------------------------------------------------------------------------
    // Plugin registry
    // --------------------------------------------------------------------------------------------
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: MESSAGE_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftDocumentDetectorPlugin()
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
        
        let layout = DocumentDetectorLayout()
        
        var documentDetectorSteps : [DocumentDetectorStep] = []
        
        self.flutterResult = result
        let args = call.arguments as! [String: Any?]
        let mobileToken = args["mobileToken"] as! String
        
        let requestTimeout = args["requestTimeout"] as? Int ?? 15
        let showStepLabel = args["showStepLabel"] as? Bool ?? true
        let showStatusLabel = args["ShowStatusLabel"] as? Bool ?? true
        let enableSound = args["enableSound"] as? Bool ?? true
        let showPopup = args["showPopup"] as? Bool ?? true
        let verify = args["verify"] as? Bool ?? false
        
        var qualityThreshold : Double = 1.8
        if let argQualityThreshold = args["qualityThreshold"] as? Double {
            qualityThreshold = argQualityThreshold
        }
               
        var colorTheme = UIColor.init(hexString: "#4CD964")
        if let argColorTheme = args["colorTheme"] as? String {
            colorTheme = UIColor.init(hexString: argColorTheme)
        }
       
        let sensorLuminosityMessage = args["iLuminosityMessage"] as? String ?? "Ambiente muito escuro"
        let sensorOrientationMessage = args["iOrientationMessage"] as? String ?? "Celular não está na horizontal"
        let sensorStabilityMessage = args["iStabilityMessage"] as? String ?? "Matenha o celular parado"
        
        if let flowData = args["flow"] as? [[String: Any]] {
            let bundle = Bundle.init(for: type(of: self))
            for (_, docStep) in flowData.enumerated() {
                let document = convertToDocument(documentType: docStep["document"] as! String)
                var audioURL : URL?
                var image : UIImage?
                
                let argStepLabel = docStep["iosStepLabel"] as? String
                
                if let argIllustration = docStep["iosIllustrationName"] as? String {
                    let imageURL = URL(fileURLWithPath: bundle.path(forResource: argIllustration, ofType: "png")!)
                    image = UIImage(data: NSData(contentsOf: imageURL)! as Data)
                } else {
                    image = getImageDocument(documentType: docStep["document"] as! String)
                }
                
                if let argAudioName = docStep["iosAudioName"] as? String {
                    audioURL = URL(fileURLWithPath: bundle.path(forResource: argAudioName, ofType: "mp3")!)
                } else {
                    audioURL = getAudioDocument(documentType: docStep["document"] as! String)
                }
                
                documentDetectorSteps.append(DocumentDetectorStep(document: document, stepLabel: argStepLabel, illustration: image, audio: audioURL))
            }
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
            .setDocumentDetectorFlow(flow: documentDetectorSteps)
            .showPopup(show : showPopup)
            .setRequestTimeout(seconds: TimeInterval(requestTimeout))
            .setHasSound(hasSound: enableSound)
            .showStepLabel(show: showStepLabel)
            .showStatusLabel(show: showStatusLabel)
            .setColorTheme(color: colorTheme)
            .setLayout(layout: layout)
            .setSensorStabilityMessage(message: sensorStabilityMessage)
            .setSensorLuminosityMessage(message: sensorLuminosityMessage)
            .setSensorOrientationMessage(message: sensorOrientationMessage)
            .verifyQuality(verify: verify, qualityThreshold: qualityThreshold)
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
        
        var captureMap : [NSMutableDictionary?]  = []
        for index in (0 ... results.captures.count - 1) {
            let capture : NSMutableDictionary! = [:]
            let capture_imagePath = saveImageToDocumentsDirectory(image: results.captures[index].image, withName: "document\(index).jpg")
            capture["imagePath"] = capture_imagePath
            if let imageUrl = results.captures[index].imageUrl {
                capture["imageUrl"] = imageUrl
            } else {
                capture["imageUrl"] = ""
            }
            capture["missedAttemps"] = results.captures[index].missedAttemps
            capture["scannedLabel"] = results.captures[index].scannedLabel
            captureMap.append(capture)
        }
        
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: true)
        response["capture_type"] = results.type
        response["capture"] = captureMap
        
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
    func convertToDocument (documentType: String) -> Document {
        switch documentType {
        case "CNH_FRONT":
            return Document.CNH_FRONT
        case "CNH_BACK":
            return Document.CNH_BACK
        case "CNH_FULL":
            return Document.CNH_FULL
        case "RG_FRONT":
            return Document.RG_FRONT
        case "RG_BACK":
            return Document.RG_BACK
        case "RG_FULL":
            return Document.RG_FULL
        default:
            return Document.OTHERS
        }
    }
    
    func getAudioDocument(documentType: String) -> URL {
        let bundle = Bundle(for: DocumentDetector.DocumentDetectorController.self)
        switch documentType {
        case "CNH_FRONT":
            return URL(fileURLWithPath: bundle.path(forResource: "frentedacnh", ofType: "mp3")!)
        case "CNH_BACK":
            return URL(fileURLWithPath: bundle.path(forResource: "versodacnh", ofType: "mp3")!)
        case "CNH_FULL":
            return URL(fileURLWithPath: bundle.path(forResource: "generic", ofType: "mp3")!)
        case "RG_FRONT":
            return URL(fileURLWithPath: bundle.path(forResource: "frentedorg", ofType: "mp3")!)
        case "RG_BACK":
            return URL(fileURLWithPath: bundle.path(forResource: "versodorg", ofType: "mp3")!)
        case "RG_FULL":
            return URL(fileURLWithPath: bundle.path(forResource: "generic", ofType: "mp3")!)
        default:
            return URL(fileURLWithPath: bundle.path(forResource: "generic", ofType: "mp3")!)
        }
    }
    
    func getImageDocument(documentType: String) -> UIImage {
        let bundle = Bundle(for: DocumentDetector.DocumentDetectorController.self)
        switch documentType {
        case "CNH_FRONT":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "cnh_frente", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        case "CNH_BACK":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "cnh_verso", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        case "CNH_FULL":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "generic_front", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        case "RG_FRONT":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "rg_frente", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        case "RG_BACK":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "rg-verso", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        case "RG_FULL":
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "generic_front", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
        default:
            let imageURL = URL(fileURLWithPath: bundle.path(forResource: "generic_front", ofType: "png")!)
            return UIImage(data: NSData(contentsOf: imageURL)! as Data)!
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
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
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

