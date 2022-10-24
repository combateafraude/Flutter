import Flutter
import UIKit
import PassiveFaceLiveness

public class SwiftPassiveFaceLivenessPlugin: NSObject, FlutterPlugin, PassiveFaceLivenessControllerDelegate {
    
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
        
        var passiveFaceLivenessBuilder = PassiveFaceLivenessSdk.Builder(mobileToken: mobileToken)
        
        passiveFaceLivenessBuilder.enableMultiLanguage(false)
        
        if let peopleId = arguments["peopleId"] as? String ?? nil {
            passiveFaceLivenessBuilder.setPersonId(peopleId)
        }
        
        if let personName = arguments["personName"] as? String ?? nil{
            passiveFaceLivenessBuilder.setPersonName(personName: personName)
        }
        
        if let personCPF = arguments["personCPF"] as? String ?? nil{
            passiveFaceLivenessBuilder.setPersonCPF(personCPF: personCPF)
        }
        
        if let useAnalytics = arguments["useAnalytics"] as? Bool ?? nil {
            passiveFaceLivenessBuilder.setAnalyticsSettings(useAnalytics: useAnalytics)
        }
        
        if let hasSound = arguments["sound"] as? Bool ?? nil {
            passiveFaceLivenessBuilder.enableSound(hasSound)
        }
        
        if let requestTimeout = arguments["requestTimeout"] as? TimeInterval ?? nil {
            passiveFaceLivenessBuilder.setNetworkSettings(requestTimeout: requestTimeout)
        }
        
        if let expireTime = arguments["expireTime"] as? String ?? nil {
            passiveFaceLivenessBuilder.setGetImageUrlExpireTime(expireTime)
        }
        
        if let delay = arguments["delay"] as? TimeInterval ?? nil {
            passiveFaceLivenessBuilder.setCurrentStepDoneDelay(currentStepDoneDelay: delay)
        }
        
        if let showPreview = arguments["showPreview"] as? [String: Any] ?? nil {
            let show = showPreview["show"] as? Bool ?? false
            let title = showPreview["title"] as? String ?? nil
            let subtitle = showPreview["subTitle"] as? String ?? nil
            let confirmLabel = showPreview["confirmLabel"] as? String ?? nil
            let retryLabel = showPreview["retryLabel"] as? String ?? nil
            passiveFaceLivenessBuilder.showPreview(show, title: title, subtitle: subtitle, confirmLabel: confirmLabel, retryLabel: retryLabel)
        }
        
        if let messageSettingsParam = arguments["messageSettings"] as? [String: Any] ?? nil {
            let stepName = messageSettingsParam["stepName"] as? String ?? nil
            let waitMessage = messageSettingsParam["waitMessage"] as? String ?? nil
            let faceNotFoundMessage = messageSettingsParam["faceNotFoundMessage"] as? String ?? nil
            let faceTooFarMessage = messageSettingsParam["faceTooFarMessage"] as? String ?? nil
            let faceNotFittedMessage = messageSettingsParam["faceNotFittedMessage"] as? String ?? nil
            let multipleFaceDetectedMessage = messageSettingsParam["multipleFaceDetectedMessage"] as? String ?? nil
            let holdItMessage = messageSettingsParam["holdItMessage"] as? String ?? nil
            let invalidFaceMessage = messageSettingsParam["invalidFaceMessage"] as? String ?? nil
            let sensorStabilityMessage = messageSettingsParam["sensorStabilityMessage"] as? String ?? nil
            let verifyingLivenessMessage = messageSettingsParam["verifyingLivenessMessage"] as? String ?? nil
            
            _ = passiveFaceLivenessBuilder.setMessageSettings(
                waitMessage: waitMessage,
                stepName: stepName,
                faceNotFoundMessage: faceNotFoundMessage,
                faceTooFarMessage: faceTooFarMessage,
                faceNotFittedMessage: faceNotFittedMessage,
                holdItMessage: holdItMessage,
                invalidFaceMessage: invalidFaceMessage,
                multipleFaceDetectedMessage: multipleFaceDetectedMessage,
                sensorStabilityMessage: sensorStabilityMessage,
                verifyingLivenessMessage: verifyingLivenessMessage)
        }
        
        if let iosSettings = arguments["iosSettings"] as? [String: Any] ?? nil {
            
            if let enableManualCapture = iosSettings["enableManualCapture"] as? Bool ?? nil {
                if(enableManualCapture){
                    if let timeEnableManualCapture = iosSettings["timeEnableManualCapture"] as? TimeInterval ?? nil {
                        passiveFaceLivenessBuilder.setImageCaptureSettings(beforePictureInterval: 2, enableManualCapture: enableManualCapture, timeManualCapture: timeEnableManualCapture)
                    }else{
                        passiveFaceLivenessBuilder.setImageCaptureSettings(beforePictureInterval: 2, enableManualCapture: enableManualCapture, timeManualCapture: 0)
                    }
                }
            }
            
            if let customization = iosSettings["customization"] as? [String: Any] ?? nil {
                
                
                let layout = PassiveFaceLivenessLayout()
                
                if let colorHex = customization["colorHex"] as? String ?? nil {
                    passiveFaceLivenessBuilder.setColorTheme(color: UIColor.init(hexString: colorHex))
                }
                
                if let showStepLabel = customization["showStepLabel"] as? Bool ?? nil {
                    passiveFaceLivenessBuilder.showStepLabel(show: showStepLabel)
                }
                
                if let showStatusLabel = customization["showStatusLabel"] as? Bool ?? nil {
                    passiveFaceLivenessBuilder.showStatusLabel(show: showStatusLabel)
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
                
                passiveFaceLivenessBuilder.setLayout(layout: layout)
            }
            
            if let sensorStability = iosSettings["sensorStability"] as? [String: Any] ?? nil {
                if let sensorStability = sensorStability["sensorStability"] as? [String: Any] ?? nil {
                    let message = sensorStability["message"] as? String ?? nil
                    let stabilityThreshold = sensorStability["stabilityThreshold"] as? Double ?? nil
                    passiveFaceLivenessBuilder.setStabilitySensorSettings(stabilityThreshold: stabilityThreshold)
                }
            }
            
            if let resolution = iosSettings["resolution"] as? String ?? nil {
                passiveFaceLivenessBuilder.setResolutionSettings(resolution: getResolutionByString(resolution: resolution))
            }
            
            if let compressionQuality = iosSettings["compressQuality"] as? Double ?? nil {
                passiveFaceLivenessBuilder.setCompressSettings(compressionQuality: compressionQuality)
            }
        }
        
        if let imageCapture = arguments["imageCapture"] as? [String: Any] ?? nil {
            if let use = imageCapture["use"] as? Bool ?? nil {
                if(use){
                    if let beforePictureMillis = imageCapture["beforePictureMillis"] as? TimeInterval ?? nil {
                        passiveFaceLivenessBuilder.setImageCaptureSettings(beforePictureInterval: beforePictureMillis, enableManualCapture: true, timeManualCapture: 10)
                    }
                    
                }
            }
        }
        
        if let videoCapture = arguments["videoCapture"] as? [String: Any] ?? nil {
            if let use = videoCapture["use"] as? Bool ?? nil {
                if(use){
                    if let time = videoCapture["time"] as? TimeInterval ?? nil {
                        passiveFaceLivenessBuilder.setVideoCaptureSettings(time: time)
                    }else{
                        passiveFaceLivenessBuilder.setVideoCaptureSettings(time: 3)
                        
                    }
                }
            }
        }
        
        if let stage = arguments["stage"] as? String ?? nil {
            passiveFaceLivenessBuilder.setStage(stage: getStageByString(stage: stage))
        }
        
        if let useOpenEyeValidation = arguments["useOpenEyeValidation"] as? Bool ?? nil {
            passiveFaceLivenessBuilder.setEyesClosedSettings(threshold: arguments["openEyesThreshold"] as? Double ?? 0.5, isEnable: useOpenEyeValidation)
        }
        
        //passiveFaceLivenessBuilder.setOverlay(overlay: PassiveFaceLivenessOverlay())
        
        let controller = UIApplication.shared.keyWindow!.rootViewController!
        
        let scannerVC = PassiveFaceLivenessController(passiveFaceLiveness: passiveFaceLivenessBuilder.build())
        scannerVC.passiveFaceLivenessDelegate = self
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
    
    public func getStageByString(stage: String) -> CAFStage {
        if(stage == "BETA"){
            return .BETA
        }else if(stage == "OTHER"){
            return .OTHER
        }else{
            return .PROD
        }
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
        }else{
            return .hd1280x720
        }
    }
    
    public func passiveFaceLivenessController(_ passiveFacelivenessController: PassiveFaceLivenessController, didFinishWithResults results: PassiveFaceLivenessResult) {
        let response : NSMutableDictionary! = [:]
        
        if let image = results.image {
            let imagePath = saveImageToDocumentsDirectory(image: image, withName: "selfie.jpg")
            response["imagePath"] = imagePath
        }
        
        response["success"] = NSNumber(value: true)
        response["capturePath"] = results.capturePath
        response["imageUrl"] = results.imageUrl
        response["signedResponse"] = results.signedResponse
        response["trackingId"] = results.trackingId
        response["lensFacing"] = results.lensFacing
        
        flutterResult!(response)
    }
    
    public func passiveFaceLivenessControllerDidCancel(_ passiveFacelivenessController: PassiveFaceLivenessController) {
        let response : NSMutableDictionary! = [:]
        
        response["success"] = nil
        
        flutterResult!(response)
    }
    
    public func passiveFaceLivenessController(_ passiveFacelivenessController: PassiveFaceLivenessController, didFailWithError error: PassiveFaceLivenessFailure) {
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
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}

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
