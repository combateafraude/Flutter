#import "AddressCheckPlugin.h"
#if __has_include(<address_check/address_check-Swift.h>)
#import <address_check/address_check-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "address_check-Swift.h"
#endif

@implementation AddressCheckPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAddressCheckPlugin registerWithRegistrar:registrar];
}
@end
