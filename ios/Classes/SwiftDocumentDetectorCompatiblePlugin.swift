import Flutter
import UIKit
import TensorFlowLite
import DocumentDetector

public class SwiftDocumentDetectorCompatiblePlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {
    
    var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "document_detector", binaryMessenger: registrar.messenger())
        let instance = SwiftDocumentDetectorCompatiblePlugin()
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
        
        if let flowData = arguments["documentSteps"] as? [[String: Any]] ?? nil {
            let bundle = Bundle.init(for: type(of: self))
            for (_, docStep) in flowData.enumerated() {
                let document = convertToDocument(documentType: docStep["document"] as! String)
                
                var audioURL: URL?
                var illustration: UIImage?
                var stepLabel: String?
                
                if let iosCustomization = docStep["ios"] as? [String: Any] ?? nil {
                    stepLabel = iosCustomization["stepLabel"] as? String ?? nil
                    
                    if let illustrationString = iosCustomization["illustration"] as? String ?? nil {
                        let imageURL = URL(fileURLWithPath: bundle.path(forResource: illustrationString, ofType: "png")!)
                        illustration = UIImage(data: NSData(contentsOf: imageURL)! as Data)
                    }
                    
                    if let audioName = iosCustomization["audioName"] as? String ?? nil {
                        audioURL = URL(fileURLWithPath: bundle.path(forResource: audioName, ofType: "mp3")!)
                    }
                }
                
                documentDetectorSteps.append(DocumentDetectorStep(document: document, stepLabel: stepLabel, illustration: illustration, audio: audioURL))
            }
        }
        
        var documentDetectorBuilder = DocumentDetectorSdk.Builder(mobileToken: mobileToken)
        
        documentDetectorBuilder.enableMultiLanguage(false)
        
        documentDetectorBuilder.setDocumentDetectorFlow(flow: documentDetectorSteps)
        
        if let useAnalytics = arguments["useAnalytics"] as? Bool ?? nil {
            documentDetectorBuilder.setAnalyticsSettings(useAnalytics: useAnalytics)
        }
        
        if let peopleId = arguments["peopleId"] as? String ?? nil {
            documentDetectorBuilder.setPersonId(personId: peopleId)
        }
        
        if let showPopup = arguments["popup"] as? Bool ?? nil {
            documentDetectorBuilder.setPopupSettings(show: showPopup)
        }
        
        if let hasSound = arguments["sound"] as? Bool ?? nil {
            documentDetectorBuilder.enableSound(enableSound: hasSound)
        }
        
        if let requestTimeout = arguments["requestTimeout"] as? TimeInterval ?? nil {
            documentDetectorBuilder.setNetworkSettings(requestTimeout: requestTimeout)
        }
        
        if let delay = arguments["delay"] as? TimeInterval ?? nil {
            documentDetectorBuilder.setCurrentStepDoneDelay(currentStepDoneDelay: delay)
        }
        
        if let showPreview = arguments["showPreview"] as? [String: Any] ?? nil {
            var show = showPreview["show"] as? Bool ?? false
            let title = showPreview["title"] as? String ?? nil
            let subtitle = showPreview["subtitle"] as? String ?? nil
            let confirmLabel = showPreview["confirmLabel"] as? String ?? nil
            let retryLabel = showPreview["retryLabel"] as? String ?? nil
            documentDetectorBuilder.showPreview(show, title: title, subtitle: subtitle, confirmLabel: confirmLabel, retryLabel: retryLabel)
        }
        
        if let messageSettingsParam = arguments["messageSettings"] as? [String: Any] ?? nil {
            let waitMessage = messageSettingsParam["waitMessage"] as? String ?? nil
            let fitTheDocumentMessage = messageSettingsParam["fitTheDocumentMessage"] as? String ?? nil
            let verifyingQualityMessage = messageSettingsParam["verifyingQualityMessage"] as? String ?? nil
            let lowQualityDocumentMessage = messageSettingsParam["lowQualityDocumentMessage"] as? String ?? nil
            let uploadingImageMessage = messageSettingsParam["uploadingImageMessage"] as? String ?? nil
            
            let popupDocumentSubtitleMessage = messageSettingsParam["popupDocumentSubtitleMessage"] as? String ?? nil
            
            let unsupportedDocumentMessage = messageSettingsParam["unsupportedDocumentMessage"] as? String ?? nil
            let wrongDocumentMessage_RG_FRONT = messageSettingsParam["wrongDocumentMessage_RG_FRONT"] as? String ?? nil
            let wrongDocumentMessage_RG_BACK = messageSettingsParam["wrongDocumentMessage_RG_BACK"] as? String ?? nil
            let wrongDocumentMessage_RG_FULL = messageSettingsParam["wrongDocumentMessage_RG_FULL"] as? String ?? nil
            let wrongDocumentMessage_CNH_FRONT = messageSettingsParam["wrongDocumentMessage_CNH_FRONT"] as? String ?? nil
            let wrongDocumentMessage_CNH_BACK = messageSettingsParam["wrongDocumentMessage_CNH_BACK"] as? String ?? nil
            let wrongDocumentMessage_CNH_FULL = messageSettingsParam["wrongDocumentMessage_CNH_FULL"] as? String ?? nil
            let wrongDocumentMessage_CRLV = messageSettingsParam["wrongDocumentMessage_CRLV"] as? String ?? nil
            let wrongDocumentMessage_RNE_FRONT = messageSettingsParam["wrongDocumentMessage_RNE_FRONT"] as? String ?? nil
            let wrongDocumentMessage_RNE_BACK = messageSettingsParam["wrongDocumentMessage_RNE_BACK"] as? String ?? nil
            
            let sensorLuminosityMessage = messageSettingsParam["sensorLuminosityMessage"] as? String ?? nil
            
            let sensorOrientationMessage = messageSettingsParam["sensorOrientationMessage"] as? String ?? nil
            
            let sensorStabilityMessage = messageSettingsParam["sensorStabilityMessage"] as? String ?? nil
            
            documentDetectorBuilder.setMessageSettings(waitMessage: waitMessage,
                                                       fitTheDocumentMessage: fitTheDocumentMessage,
                                                       verifyingQualityMessage: verifyingQualityMessage,
                                                       lowQualityDocumentMessage: lowQualityDocumentMessage,
                                                       uploadingImageMessage: uploadingImageMessage,
                                                       popupDocumentSubtitleMessage: popupDocumentSubtitleMessage,
                                                       unsupportedDocumentMessage: unsupportedDocumentMessage,
                                                       wrongDocumentMessage_RG_FRONT: wrongDocumentMessage_RG_FRONT,
                                                       wrongDocumentMessage_RG_BACK: wrongDocumentMessage_RG_BACK,
                                                       wrongDocumentMessage_RG_FULL: wrongDocumentMessage_RG_FULL,
                                                       wrongDocumentMessage_CNH_FRONT: wrongDocumentMessage_CNH_FRONT,
                                                       wrongDocumentMessage_CNH_BACK: wrongDocumentMessage_CNH_BACK,
                                                       wrongDocumentMessage_CNH_FULL: wrongDocumentMessage_CNH_FULL,
                                                       wrongDocumentMessage_CRLV: wrongDocumentMessage_CRLV,
                                                       wrongDocumentMessage_RNE_FRONT: wrongDocumentMessage_RNE_FRONT,
                                                       wrongDocumentMessage_RNE_BACK: wrongDocumentMessage_RNE_BACK,
                                                       sensorLuminosityMessage: sensorLuminosityMessage,
                                                       sensorOrientationMessage: sensorOrientationMessage,
                                                       sensorStabilityMessage: sensorStabilityMessage)
        }
        
        if let iosSettings = arguments["iosSettings"] as? [String: Any] ?? nil {
            if let detectionThreshold = iosSettings["detectionThreshold"] as? Float ?? nil {
                documentDetectorBuilder.setDetectionSettings(detectionThreshold: detectionThreshold)
            }
            
            if let enableManualCapture = iosSettings["enableManualCapture"] as? Bool ?? nil {
                if(enableManualCapture){
                    if let timeEnableManualCapture = iosSettings["timeEnableManualCapture"] as? Double ?? nil {
                        documentDetectorBuilder.setManualCaptureSettings(enable: enableManualCapture, time: timeEnableManualCapture)
                    }else{
                        documentDetectorBuilder.setManualCaptureSettings(enable: enableManualCapture, time: 0)
                    }
                }
            }
            
            if let verifyQuality = iosSettings["verifyQuality"] as? Bool ?? nil {
                let qualityThreshold = iosSettings["qualityThreshold"] as? Double ?? nil
                documentDetectorBuilder.setQualitySettings(verifyQuality: verifyQuality, qualityThreshold: qualityThreshold)
            }
            
            if let sensorStability = iosSettings["sensorStability"] as? [String: Any] ?? nil {
                
                if let sensorLuminosity = iosSettings["sensorLuminosity"] as? [String: Any] ?? nil {
                    let luminosityThreshold = sensorLuminosity["luminosityThreshold"] as? Float ?? nil
                    documentDetectorBuilder.setLuminositySensorSettings(luminosityThreshold: luminosityThreshold)
                }
                
                if let sensorOrientation = iosSettings["sensorOrientation"] as? [String: Any] ?? nil {
                    let orientationThreshold = sensorOrientation["orientationThreshold"] as? Double ?? nil
                    documentDetectorBuilder.setOrientationSensorSettings(orientationThreshold: orientationThreshold)
                }
                
                if let sensorStability = iosSettings["sensorStability"] as? [String: Any] {
                    let stabilityThreshold = sensorStability["stabilityThreshold"] as? Double ?? nil
                    documentDetectorBuilder.setStabilitySensorSettings(stabilityThreshold: stabilityThreshold)
                }
                
            }
            
            if let resolution = iosSettings["resolution"] as? String ?? nil {
                documentDetectorBuilder.setResolutionSettings(resolution: getResolutionByString(resolution: resolution))
            }
            
            if let compressionQuality = iosSettings["compressQuality"] as? Double ?? nil {
                documentDetectorBuilder.setCompressSettings(compressionQuality: compressionQuality)
            }
            
            
            if let customization = iosSettings["customization"] as? [String: Any] ?? nil {
                
                let layout = DocumentDetectorLayout()
                
                if let colorHex = customization["colorHex"] as? String ?? nil {
                    documentDetectorBuilder.setColorTheme(color: UIColor.init(hexString: colorHex))
                }
                
                if let showStepLabel = customization["showStepLabel"] as? Bool ?? nil {
                    documentDetectorBuilder.showStepLabel(show: showStepLabel)
                }
                
                if let showStatusLabel = customization["showStatusLabel"] as? Bool ?? nil {
                    documentDetectorBuilder.showStatusLabel(show: showStatusLabel)
                }
                
                if let closeImageName = customization["closeImageName"] as? String ?? nil {
                    layout.closeImage = UIImage(named: closeImageName)
                }
                
                var greenMask : UIImage?
                if let greenMaskImageName = customization["greenMaskImageName"] as? String ?? nil {
                    greenMask = UIImage(named: greenMaskImageName)
                }
                
                var whiteMask : UIImage?
                if let whiteMaskImageName = customization["whiteMaskImageName"] as? String ?? nil {
                    whiteMask = UIImage(named: whiteMaskImageName)
                }
                
                var redMask : UIImage?
                if let redMaskImageName = customization["redMaskImageName"] as? String ?? nil {
                    redMask = UIImage(named: redMaskImageName)
                }
                
                layout.changeMaskImages(
                    greenMask: greenMask,
                    whiteMask: whiteMask,
                    redMask: redMask)
                
                if let buttonSize = customization["buttonSize"] as? Double ?? nil {
                    layout.buttonSize = CGFloat(buttonSize)
                }
                
                if let contentModeParam = customization["buttonContentMode"] as? String ?? nil {
                    if let contentMode = getContentModeByString(contentModeParam){
                        layout.buttonContentMode = contentMode
                    }
                }
                
                
                documentDetectorBuilder.setLayout(layout: layout)
            }
        }
        
        if let uploadSettingsParam = arguments["uploadSettings"] as? [String: Any] ?? nil {
            let compress = uploadSettingsParam["compress"] as? Bool ?? true
            let fileFormatsParam = uploadSettingsParam["fileFormats"] as? [String] ?? nil
            let fileFormats = getFileFormatsArrayByStringArray(fileFormatsParam: fileFormatsParam) ?? [.jpeg, .png, .pdf]
            let maxFileSize = uploadSettingsParam["maxFileSize"] as? Int ?? 10000000
            
            _ = documentDetectorBuilder.setUploadSettings(uploadSettings: UploadSettings(enable: true, compress: compress, fileFormats: fileFormats, maximumFileSize: maxFileSize))
        }
        
        //documentDetectorBuilder.setOverlay(overlay: DocumentDetectorOverlay())
        
        let controller = UIApplication.shared.keyWindow!.rootViewController!
        
        let scannerVC = DocumentDetectorController(documentDetector: documentDetectorBuilder.build())
        scannerVC.documentDetectorDelegate = self
        controller.present(scannerVC, animated: true, completion: nil)
    }
    
    func getContentModeByString(_ contentModeParam: String) -> UIView.ContentMode? {
            if(contentModeParam == "scaleToFill"){
                return .scaleToFill
            }else if(contentModeParam == "scaleAspectFit"){
                return .scaleAspectFit
            }else if(contentModeParam == "scaleAspectFill"){
                return .scaleAspectFill
            }else if(contentModeParam == "redraw"){
                return .redraw
            }else if(contentModeParam == "center"){
                return .center
            }else if(contentModeParam == "top"){
                return .top
            }else if(contentModeParam == "bottom"){
                return .bottom
            }else if(contentModeParam == "left"){
                return .left
            }else if(contentModeParam == "topLeft"){
                return .topLeft
            }else if(contentModeParam == "topRight"){
                return .topRight
            }else if(contentModeParam == "bottomLeft"){
                return .bottomLeft
            }else if(contentModeParam == "bottomRight"){
                return .bottomRight
            }

            return nil
        }

        func getFileFormatsArrayByStringArray(fileFormatsParam: [String]?) -> [FileFormat]? {

            var fileFormats: [FileFormat]? = nil

            if let fileFormatsParam = fileFormatsParam {
                fileFormats = []
                for format in fileFormatsParam {
                    fileFormats?.append(getFileFormatByString(fileFormatString: format))
                }
            }

            return fileFormats
        }

        func getFileFormatByString(fileFormatString: String) -> FileFormat {
            if(fileFormatString == "PNG"){
                return .png
            }else if(fileFormatString == "JPG" || fileFormatString == "JPEG"){
                return .jpeg
            }else if(fileFormatString == "PDF"){
                return .pdf
            }

            return .jpeg
        }
    
    public func getResolutionByString(resolution: String) -> Resolution {
        if(resolution == "LOW"){
            return .low
        }else if(resolution == "MEDIUM"){
            return .medium
        }else if(resolution == "HIGH"){
            return .high
        }else if(resolution == "PHOTO"){
            return .photo
        }else if(resolution == "INPUT_PRIORITY"){
            return .inputPriority
        }else if(resolution == "hd1280x720"){
            return .hd1280x720
        }else if(resolution == "hd1920x1080"){
            return .hd1920x1080
        }else if(resolution == "hd4K3840x2160"){
            return .hd4K3840x2160
        }else if(resolution == "iFrame960x540"){
            return .iFrame960x540
        }else if(resolution == "iFrame1280x720"){
            return .iFrame1280x720
        }else if(resolution == "VGA640x480"){
            return .vga640x480
        }else if(resolution == "CIF352x288"){
            return .cif352x288
        }
        
        return .hd1280x720
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
        case "PASSPORT":
            return Document.PASSPORT
        case "CTPS_FRONT":
            return Document.CTPS_FRONT
        case "CTPS_BACK":
            return Document.CTPS_BACK
        case "ANY":
            return Document.ANY
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
