#import "DocumentDetectorCompatiblePlugin.h"
#if __has_include(<document_detector_compatible/document_detector_compatible-Swift.h>)
#import <document_detector_compatible/document_detector_compatible-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "document_detector_compatible-Swift.h"
#endif

@implementation DocumentDetectorCompatiblePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentDetectorCompatiblePlugin registerWithRegistrar:registrar];
}
@end
