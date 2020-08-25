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
        
        var passiveFaceLivenessBuilder = PassiveFaceLivenessBuilder(apiToken: mobileToken)

        if let hasSound = arguments["sound"] as! Bool? {
            passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.enableSound(enableSound: hasSound)
        }

        if let requestTimeout = arguments["requestTimeout"] as? TimeInterval {
            passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.setNetworkSettings(requestTimeout: requestTimeout)
        }

        if let iosSettings = arguments["iosSettings"] as? [String: Any] {

            if let customization = iosSettings["customization"] as? [String: Any] {

                let layout = PassiveFaceLivenessLayout()

                if let colorHex = customization["colorHex"] as? String {
                    passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.setColorTheme(color: UIColor.init(hexString: colorHex))
                }

                if let showStepLabel = customization["showStepLabel"] as? Bool {
                    passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.showStepLabel(show: showStepLabel)
                }

                if let showStatusLabel = customization["showStatusLabel"] as? Bool {
                    passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.showStatusLabel(show: showStatusLabel)
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

                
                passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.setLayout(layout: layout)
            }

            if let beforePictureMillis = iosSettings["beforePictureMillis"] as? TimeInterval {
                passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.setCaptureSettings(beforePictureInterval: beforePictureMillis)
            }

            if let sensorStability = iosSettings["sensorStability"] as? [String: Any] {
                if let sensorStability = sensorStability["sensorStability"] as? [String: Any] {
                    let message = sensorStability["message"] as! String?
                    let stabilityThreshold = sensorStability["stabilityThreshold"] as! Double?
                    passiveFaceLivenessBuilder = passiveFaceLivenessBuilder.setStabilitySensorSettings(message: message, stabilityThreshold: stabilityThreshold)
                }
            }
        }
        
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        let scannerVC = PassiveFaceLivenessController(passiveFaceLivenessConfiguration: passiveFacelivenessConfiguration)
        scannerVC.passiveFaceLivenessDelegate = self
        controller.present(scannerVC, animated: true, completion: nil)
    }
    
    public func passiveFaceLivenessController(_ passiveFacelivenessController: PassiveFaceLivenessController, didFinishWithResults results: PassiveFaceLivenessResult) {
        let response : NSMutableDictionary! = [:]

        let imagePath = saveImageToDocumentsDirectory(image: results.image, withName: "selfie.jpg")
        response["success"] = NSNumber(value: true)
        response["imagePath"] = imagePath
        response["imageUrl"] = results.imageUrl
        response["signedResponse"] = results.signedResponse

        flutterResult!(response)
    }
    
    public func passiveFaceLivenessControllerDidCancel(_ passiveFacelivenessController: PassiveFaceLivenessController) {
        let response : NSMutableDictionary! = [:]

        response["success"] = nil

        flutterResult!(response)
    }
    
    public func passiveFaceLivenessController(_ passiveFacelivenessController: PassiveFaceLivenessController, didFailWithError error: SDKFailure) {
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
