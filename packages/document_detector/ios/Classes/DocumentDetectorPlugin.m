#import "DocumentDetectorPlugin.h"
#if __has_include(<document_detector/document_detector-Swift.h>)
#import <document_detector/document_detector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "document_detector-Swift.h"
#endif

@implementation DocumentDetectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentDetectorPlugin registerWithRegistrar:registrar];
}
@end
