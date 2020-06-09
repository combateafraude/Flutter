#import "DocumentDetectorSdkPlugin.h"
#if __has_include(<document_detector_sdk/document_detector_sdk-Swift.h>)
#import <document_detector_sdk/document_detector_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "document_detector_sdk-Swift.h"
#endif

@implementation DocumentDetectorSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentDetectorSdkPlugin registerWithRegistrar:registrar];
}
@end
