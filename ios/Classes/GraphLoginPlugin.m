#import "GraphLoginPlugin.h"
#if __has_include(<graph_login/graph_login-Swift.h>)
#import <graph_login/graph_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "graph_login-Swift.h"
#endif

@implementation GraphLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGraphLoginPlugin registerWithRegistrar:registrar];
}
@end
