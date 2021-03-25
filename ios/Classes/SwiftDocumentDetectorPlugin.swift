import Flutter
import UIKit
import TensorFlowLite
import DocumentDetector

public class SwiftDocumentDetectorPlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {

    var flutterResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "document_detector", binaryMessenger: registrar.messenger())
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
                let document = convertToDocument(documentType: docStep["document"] as! String)
                
                var audioURL: URL?
                var illustration: UIImage?
                var stepLabel: String?

                if let iosCustomization = docStep["ios"] as? [String: Any] {
                    stepLabel = iosCustomization["stepLabel"] as? String
                    
                    if let illustrationString = iosCustomization["illustration"] as? String {
                        let imageURL = URL(fileURLWithPath: bundle.path(forResource: illustrationString, ofType: "png")!)
                        illustration = UIImage(data: NSData(contentsOf: imageURL)! as Data)
                    }
                    
                    if let audioName = iosCustomization["audioName"] as? String {
                        audioURL = URL(fileURLWithPath: bundle.path(forResource: audioName, ofType: "mp3")!)
                    }
                }
                
                documentDetectorSteps.append(DocumentDetectorStep(document: document, stepLabel: stepLabel, illustration: illustration, audio: audioURL))
            }
        }

        var documentDetectorBuilder = DocumentDetector.Builder(mobileToken: mobileToken)
            .setDocumentDetectorFlow(flow: documentDetectorSteps)

        if let useAnalytics = arguments["useAnalytics"] as! Bool? {
            documentDetectorBuilder.setAnalyticsSettings(useAnalytics: useAnalytics)
        }

        if let peopleId = arguments["peopleId"] as! String? {
            documentDetectorBuilder.setPeopleId(peopleId: peopleId)
        }
        
        if let showPopup = arguments["popup"] as! Bool? {
            documentDetectorBuilder.setPopupSettings(show: showPopup)
        }

        if let hasSound = arguments["sound"] as! Bool? {
            documentDetectorBuilder.enableSound(enableSound: hasSound)
        }

        if let requestTimeout = arguments["requestTimeout"] as? TimeInterval {
            documentDetectorBuilder.setNetworkSettings(requestTimeout: requestTimeout)
        }

        if let showPreview = arguments["showPreview"] as? [String: Any] {
            var show = showPreview["show"] as? Bool
            if(show == nil){
                show = false
            }
            let title = showPreview["title"] as? String
            let subtitle = showPreview["subTitle"] as? String
            let confirmLabel = showPreview["confirmLabel"] as? String
            let retryLabel = showPreview["retryLabel"] as? String
            documentDetectorBuilder.showPreview(show!, title: title, subtitle: subtitle, confirmLabel: confirmLabel, retryLabel: retryLabel)
         }

        if let iosSettings = arguments["iosSettings"] as? [String: Any] {
            if let detectionThreshold = iosSettings["detectionThreshold"] as? Float {
                documentDetectorBuilder.setDetectionSettings(detectionThreshold: detectionThreshold)
            }

            if let verifyQuality = iosSettings["verifyQuality"] as? Bool {
                let qualityThreshold = iosSettings["qualityThreshold"] as? Double
                documentDetectorBuilder.setQualitySettings(verifyQuality: verifyQuality, qualityThreshold: qualityThreshold)
            }

            if let sensorStability = iosSettings["sensorStability"] as? [String: Any] {

                if let sensorLuminosity = iosSettings["sensorLuminosity"] as? [String: Any] {
                    let message = sensorLuminosity["message"] as! String?
                    let luminosityThreshold = sensorLuminosity["luminosityThreshold"] as! Float?
                    documentDetectorBuilder.setLuminositySensorSettings(message: message, luminosityThreshold: luminosityThreshold)
                }

                if let sensorOrientation = iosSettings["sensorOrientation"] as? [String: Any] {
                    let message = sensorOrientation["message"] as! String?
                    let orientationThreshold = sensorOrientation["orientationThreshold"] as! Double?
                    documentDetectorBuilder.setOrientationSensorSettings(message: message, orientationThreshold: orientationThreshold)
                }

                if let sensorStability = iosSettings["sensorStability"] as? [String: Any] {
                    let message = sensorStability["message"] as! String?
                    let stabilityThreshold = sensorStability["stabilityThreshold"] as! Double?
                    documentDetectorBuilder.setStabilitySensorSettings(message: message, stabilityThreshold: stabilityThreshold)
                }

            }
            
            if let customization = iosSettings["customization"] as? [String: Any] {

                let layout = DocumentDetectorLayout()

                if let colorHex = customization["colorHex"] as? String {
                    documentDetectorBuilder.setColorTheme(color: UIColor.init(hexString: colorHex))
                }

                if let showStepLabel = customization["showStepLabel"] as? Bool {
                    documentDetectorBuilder.showStepLabel(show: showStepLabel)
                }

                if let showStatusLabel = customization["showStatusLabel"] as? Bool {
                    documentDetectorBuilder.showStatusLabel(show: showStatusLabel)
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

                
                documentDetectorBuilder.setLayout(layout: layout)
            }
        }
        
        let controller = UIApplication.shared.keyWindow!.rootViewController!
        
        let scannerVC = DocumentDetectorController(documentDetector: documentDetectorBuilder.build())
        scannerVC.documentDetectorDelegate = self
        controller.present(scannerVC, animated: true, completion: nil)
    }

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
        case "CRLV":
            return Document.CRLV
        case "RNE_FRONT":
            return Document.RNE_FRONT
        case "RNE_BACK":
            return Document.RNE_BACK
        default:
            return Document.OTHERS
        }
    }
    
    //---------------------------------------------------------------------------------------------
    // Delegates
    // --------------------------------------------------------------------------------------------
    
    public func documentDetectionController(_ scanner: DocumentDetectorController, didFinishWithResults results: DocumentDetectorResult) {
        var captureMap : [NSMutableDictionary?]  = []
        for index in (0 ... results.captures.count - 1) {
            let capture : NSMutableDictionary! = [:]
            let imagePath = saveImageToDocumentsDirectory(image: results.captures[index].image, withName: "document\(index).jpg")
            capture["imagePath"] = imagePath
            capture["imageUrl"] = results.captures[index].imageUrl
            capture["quality"] = results.captures[index].quality
            capture["label"] = results.captures[index].scannedLabel
            captureMap.append(capture)
        }
        
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: true)
        response["type"] = results.type
        response["captures"] = captureMap
        response["trackingId"] = results.trackingId
        
        flutterResult!(response)
    }
    
    public func documentDetectionControllerDidCancel(_ scanner: DocumentDetectorController) {
        let response : NSMutableDictionary! = [:]
        response["success"] = nil
        flutterResult!(response)
    }
    
    public  func documentDetectionController(_ scanner: DocumentDetectorController, didFailWithError error:  DocumentDetectorFailure) {
        let response : NSMutableDictionary! = [:]
        response["success"] = NSNumber(value: false)
        response["message"] = error.message
        response["type"] = String(describing: type(of: error))
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
