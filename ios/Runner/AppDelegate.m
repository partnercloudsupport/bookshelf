#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

    FlutterMethodChannel* screenChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"bookshelf.fuyumi.com/screen"
                                          binaryMessenger:controller];
    [screenChannel setMethodCallHandler:^(FlutterMethodCall* methodCall, FlutterResult result) {
      if ([@"activateKeepScreenOn" isEqualToString:methodCall.method]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        });
      } else if ([@"deactivateKeepScreenOn" isEqualToString:methodCall.method]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        });
      } else {
        result(FlutterMethodNotImplemented);
      }
    }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
