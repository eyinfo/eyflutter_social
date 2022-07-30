#import "EyflutterSocialPlugin.h"
#if __has_include(<eyflutter_social/eyflutter_social-Swift.h>)
#import <eyflutter_social/eyflutter_social-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "eyflutter_social-Swift.h"
#endif

@implementation EyflutterSocialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEyflutterSocialPlugin registerWithRegistrar:registrar];
}
@end
