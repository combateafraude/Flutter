#import "PassivefaceLivenessSdkPlugin.h"
#if __has_include(<passiveface_liveness_sdk/passiveface_liveness_sdk-Swift.h>)
#import <passiveface_liveness_sdk/passiveface_liveness_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "passiveface_liveness_sdk-Swift.h"
#endif

@implementation PassivefaceLivenessSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPassivefaceLivenessSdkPlugin registerWithRegistrar:registrar];
}
@end
