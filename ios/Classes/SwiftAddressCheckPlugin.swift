import Flutter
import UIKit
import AddressCheck

public class SwiftAddressCheckPlugin: NSObject, FlutterPlugin, AddressCollectionDelegate {
    
    var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "address_check", binaryMessenger: registrar.messenger())
        let instance = SwiftAddressCheckPlugin()
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

        AddressCheck.initSDK()

        let arguments = call.arguments as! [String: Any?]
        
        let mobileToken = arguments["mobileToken"] as! String
        let peopleId = arguments["peopleId"] as! String
        
        var addressCheckBuilder = AddressCheck.Builder(mobileToken: mobileToken, peopleId: peopleId)

        if let useAnalytics = arguments["useAnalytics"] as! Bool? {
            addressCheckBuilder.setAnalyticsSettings(useAnalytics: useAnalytics)
        }

        if let requestTimeout = arguments["requestTimeout"] as? TimeInterval {
            addressCheckBuilder.setNetworkSettings(requestTimeout: requestTimeout)
        }

        if let address = arguments["address"] as? [String: Any] {
            let countryName = address["countryName"] as? String
            let countryCode = address["countryCode"] as? String
            let adminArea = address["adminArea"] as? String
            let subAdminArea = address["subAdminArea"] as? String
            let locality = address["locality"] as? String
            let subLocality = address["subLocality"] as? String
            let thoroughfare = address["thoroughfare"] as? String
            let subThoroughfare = address["subThoroughfare"] as? String
            let postalCode = address["postalCode"] as? String

            let address = Address()
            address.locale = Locale.init(identifier: "pt-br")
            address.countryName = countryName
            address.countryCode = countryCode
            address.adminArea = adminArea
            address.subAdminArea = subAdminArea
            address.locality = locality
            address.subLocality = subLocality
            address.thoroughfare = thoroughfare
            address.subThoroughfare = subThoroughfare
            address.postalCode = postalCode

            let addressCheck = addressCheckBuilder.bluid()

            let addressCollection = AddressCollection(addressCheck: addressCheck)
            addressCollection.delegate = self
            addressCollection.setAddress(address)
        }
        
    }
    
    public func onSucess() {
        let response : NSMutableDictionary! = [:]
        response["success"] = true
        flutterResult!(response)
    }
    
    public func onError(error: AddressCheckFailure) {
        let response : NSMutableDictionary! = [:]
        response["success"] = false
        flutterResult!(response)
    }
    
    
}
