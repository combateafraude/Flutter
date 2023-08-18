#import "PassiveFaceLivenessPlugin.h"
#if __has_include(<new_face_liveness_compatible/new_face_liveness_compatible-Swift.h>)
#import <new_face_liveness_compatible/new_face_liveness_compatible-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "new_face_liveness_compatible-Swift.h"
#endif

@implementation PassiveFaceLivenessPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPassiveFaceLivenessPlugin registerWithRegistrar:registrar];
}
@end