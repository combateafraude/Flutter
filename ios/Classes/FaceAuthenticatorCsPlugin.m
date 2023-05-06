#import "FaceAuthenticatorCsPlugin.h"
#if __has_include(<face_authenticator_cs/face_authenticator_cs-Swift.h>)
#import <face_authenticator_cs/face_authenticator_cs-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "face_authenticator_cs-Swift.h"
#endif

@implementation FaceAuthenticatorCsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFaceAuthenticatorCsPlugin registerWithRegistrar:registrar];
}
@end
