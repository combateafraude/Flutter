#import "FaceAuthenticatorPlugin.h"
#if __has_include(<face_authenticator/face_authenticator-Swift.h>)
#import <face_authenticator/face_authenticator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "face_authenticator-Swift.h"
#endif

@implementation FaceAuthenticatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFaceAuthenticatorPlugin registerWithRegistrar:registrar];
}
@end
