import Flutter
import UIKit

public class SwiftDocumentDetectorPlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {

    var methodChannel: FlutterMethodChannel?
    var flutterResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        methodChannel = FlutterMethodChannel(name: "document_detector", binaryMessenger: registrar.messenger())
        let instance = SwiftDocumentDetectorPlugin()
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
        
        var documentDetectorSteps : [DocumentDetectorStep] = []

        if let flowData = arguments["documentSteps"] as? [[String: Any]] {
            let bundle = Bundle.init(for: type(of: self))
            for (_, docStep) in flowData.enumerated() {
                let document = Document(rawValue: docStep["document"] as! String)
                
                let iosCustomization = docStep["ios"] as? [[String: Any]]
                
                let stepLabel = iosCustomization["stepLabel"] as? String
                
                var image : UIImage?
                if let illustration = iosCustomization["illustration"] as? String {
                    let imageURL = URL(fileURLWithPath: bundle.path(forResource: illustration, ofType: "png")!)
                    image = UIImage(data: NSData(contentsOf: imageURL)! as Data)
                }
                
                var audioURL : URL?
                if let audioName = iosCustomization["audioName"] as? String {
                    audioURL = URL(fileURLWithPath: bundle.path(forResource: audioName, ofType: "mp3")!)
                }
                
                documentDetectorSteps.append(DocumentDetectorStep(document: document, stepLabel: stepLabel, illustration: image, audio: audioURL))
            }
        }

        let documentDetectorConfiguration = DocumentDetectorBuilder(apiToken: mobileToken)
            .setDocumentDetectorFlow(flow: documentDetectorSteps)

        if let showPopup = arguments["popup"] as! Bool {
            documentDetectorConfiguration.setPopupSettings(showPopup)
        }

        if let hasSound = arguments["sound"] as! Bool {
            documentDetectorConfiguration.enableSound(hasSound)
        }

        if let requestTimeout = arguments["requestTimeout"] as! Int {
            documentDetectorConfiguration.setNetworkSettings(requestTimeout)
        }

        if let iosSettings = arguments["iosSettings"] as? [[String: Any]] {
            if let detectionThreshold = iosSettings["detectionThreshold"] as! Float {
                documentDetectorConfiguration.setDetectionSettings(detectionThreshold)
            }

            if let verifyQuality = iosSettings["verifyQuality"] as! Bool {
                let qualityThreshold = iosSettings["qualityThreshold"] as! Double?
                documentDetectorConfiguration.setQualitySettings(verifyQuality, qualityThreshold)
            }

            if let colorHex = iosSettings["colorHex"] as! String {
                documentDetectorConfiguration.setColorTheme(UIColor.init(hexString: colorHex))
            }

            if let sensorLuminosity = iosSettings["sensorLuminosity"] as? [[String: Any]] {
                let message = sensorLuminosity["message"] as! String?
                let luminosityThreshold = sensorLuminosity["luminosityThreshold"] as! Float?
                documentDetectorConfiguration.setSensorLuminosityMessage(message: message, luminosityThreshold: luminosityThreshold)
            }

            if let sensorOrientation = iosSettings["sensorOrientation"] as? [[String: Any]] {
                let message = sensorOrientation["message"] as! String?
                let orientationThreshold = sensorOrientation["orientationThreshold"] as! Double?
                documentDetectorConfiguration.setSensorOrientationMessage(message: message, orientationThreshold: orientationThreshold)
            }

            if let sensorStability = iosSettings["sensorStability"] as? [[String: Any]] {
                let message = sensorStability["message"] as! String?
                let stabilityThreshold = sensorStability["stabilityThreshold"] as! Double?
                documentDetectorConfiguration.setSensorStabilityMessage(message: message, stabilityThreshold: stabilityThreshold)
            }

            let layout = DocumentDetectorLayout()
            
            if let customization = iosSettings["customization"] as? [String: Any] {
                if let showStepLabel = customization["showStepLabel"] as! Bool? {
                    documentDetectorConfiguration.showStepLabel(show: showStepLabel)
                }

                if let showStatusLabel = customization["showStatusLabel"] as! Bool? {
                    documentDetectorConfiguration.showStatusLabel(show: showStatusLabel)
                }
                
                if let closeImageName = customization["closeImageName"] as? String {
                    layout.closeImage = UIImage(named: closeImageName)
                }
                
                var greenMask : UIImage?
                if let greenMaskImageName = customization["greenMaskImageName"] as? String {
                    greenMask = UIImage(named: greenMaskImageName) 
                }
                
                var whiteMask : UIImage?
                if let whiteMaskImageName = customization["whiteMaskImageName"] as? String {
                    whiteMask = UIImage(named: whiteMaskImageName) 
                }
                
                var redMask : UIImage?
                if let redMaskImageName = customization["redMaskImageName"] as? String {
                    redMask = UIImage(named: redMaskImageName) 
                }
                
                layout.changeMaskImages(
                    greenMask: greenMask,
                    whiteMask: whiteMask,
                    redMask: redMask)

                
                documentDetectorConfiguration.setLayout(layout: layout)
            }
        }
        
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        let scannerVC = DocumentDetectorController(documentDetectorConfiguration: documentDetectorConfiguration.build())
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
