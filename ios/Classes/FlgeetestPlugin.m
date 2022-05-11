#import "FlgeetestPlugin.h"
#if __has_include(<flgeetest/flgeetest-Swift.h>)
#import <flgeetest/flgeetest-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flgeetest-Swift.h"
#endif

@implementation FlgeetestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlgeetestPlugin registerWithRegistrar:registrar];
}
@end
