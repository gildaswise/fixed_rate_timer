#import "FixedRateTimerPlugin.h"
#if __has_include(<fixed_rate_timer/fixed_rate_timer-Swift.h>)
#import <fixed_rate_timer/fixed_rate_timer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fixed_rate_timer-Swift.h"
#endif

@implementation FixedRateTimerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFixedRateTimerPlugin registerWithRegistrar:registrar];
}
@end
