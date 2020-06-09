#import "ActivefaceLivenessSdkPlugin.h"
#if __has_include(<activeface_liveness_sdk/activeface_liveness_sdk-Swift.h>)
#import <activeface_liveness_sdk/activeface_liveness_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "activeface_liveness_sdk-Swift.h"
#endif

@implementation ActivefaceLivenessSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftActivefaceLivenessSdkPlugin registerWithRegistrar:registrar];
}
@end
