#import "FaceLivenessPlugin.h"
#if __has_include(<face_liveness/face_liveness-Swift.h>)
#import <face_liveness/face_liveness-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "face_liveness-Swift.h"
#endif

@implementation FaceLivenessPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFaceLivenessPlugin registerWithRegistrar:registrar];
}
@end
