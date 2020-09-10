import Flutter
import UIKit
import FaceAuthenticator

let MESSAGE_CHANNEL = "com.combateafraude.face_authenticator/message"
let ERROR_CODE = "FACE_AUTHENTICATOR_SDK_ERROR"

public class SwiftFaceAuthenticatorPlugin: NSObject, FlutterPlugin, FaceAuthenticatorControllerDelegate {

    var flutterResult: FlutterResult?

        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: "face_authenticator", binaryMessenger: registrar.messenger())
            let instance = SwiftFaceAuthenticatorPlugin()
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

            var faceAuthenticatorBuilder = FaceAuthenticatorBuilder(apiToken: mobileToken)

            if let hasSound = arguments["sound"] as! Bool? {
                faceAuthenticatorBuilder = faceAuthenticatorBuilder.enableSound(hasSound: hasSound)
            }

            if let requestTimeout = arguments["requestTimeout"] as? TimeInterval {
                faceAuthenticatorBuilder = faceAuthenticatorBuilder.setNetworkSettings(requestTimeout: requestTimeout)
            }

            if let iosSettings = arguments["iosSettings"] as? [String: Any] {

                if let customization = iosSettings["customization"] as? [String: Any] {

                    let layout = FaceAuthenticatorLayout()

                    if let colorHex = customization["colorHex"] as? String {
                        faceAuthenticatorBuilder = faceAuthenticatorBuilder.setColorTheme(color: UIColor.init(hexString: colorHex))
                    }

                    if let showStepLabel = customization["showStepLabel"] as? Bool {
                        faceAuthenticatorBuilder = faceAuthenticatorBuilder.showStepLabel(show: showStepLabel)
                    }

                    if let showStatusLabel = customization["showStatusLabel"] as? Bool {
                        faceAuthenticatorBuilder = faceAuthenticatorBuilder.showStatusLabel(show: showStatusLabel)
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


                    faceAuthenticatorBuilder = faceAuthenticatorBuilder.setLayout(layout: layout)
                }

                if let beforePictureMillis = iosSettings["beforePictureMillis"] as? TimeInterval {
                    faceAuthenticatorBuilder = faceAuthenticatorBuilder.setCaptureSettings(beforePictureInterval: beforePictureMillis)
                }


                if let sensorStability = iosSettings["sensorStability"] as? [String: Any] {
                    if let sensorStability = sensorStability["sensorStability"] as? [String: Any] {
                        let message = sensorStability["message"] as! String?
                        let stabilityThreshold = sensorStability["stabilityThreshold"] as! Double?
                        //faceAuthenticatorBuilder = faceAuthenticatorBuilder.setStabilitySensorSettings(message: message, stabilityThreshold: stabilityThreshold)
                    }
                }

            }

            let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController

            let scannerVC = FaceAuthenticatorController(faceAuthenticatorConfiguration: faceAuthenticatorBuilder.build())
            scannerVC.faceAuthenticatorDelegate = self
            controller.present(scannerVC, animated: true, completion: nil)
        }

        public func faceAuthenticatorController(_ faceAuthenticatorController: FaceAuthenticatorController, didFinishWithResults results: FaceAuthenticatorResult) {
            let response : NSMutableDictionary! = [:]

            response["success"] = NSNumber(value: true)
            response["authenticated"] = results.authenticated
            response["signedResponse"] = results.signedResponse

            flutterResult!(response)
        }

        public func faceAuthenticatorControllerDidCancel(_ faceAuthenticatorController: FaceAuthenticatorController) {
            let response : NSMutableDictionary! = [:]

            response["success"] = nil

            flutterResult!(response)
        }

        public func faceAuthenticatorController(_ faceAuthenticatorController: FaceAuthenticatorController, didFailWithError error: SDKFailure) {
            let response : NSMutableDictionary! = [:]

            response["success"] = NSNumber(value: false)
            response["message"] = error.message
            response["type"] = String(describing: type(of: error))

            flutterResult!(response)
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