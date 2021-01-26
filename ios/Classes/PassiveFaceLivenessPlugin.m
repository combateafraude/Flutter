#import "PassiveFaceLivenessPlugin.h"
#if __has_include(<passive_face_liveness_nodatabinding/passive_face_liveness_nodatabinding-Swift.h>)
#import <passive_face_liveness_nodatabinding/passive_face_liveness_nodatabinding-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "passive_face_liveness_nodatabinding-Swift.h"
#endif

@implementation PassiveFaceLivenessPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPassiveFaceLivenessPlugin registerWithRegistrar:registrar];
}
@end
