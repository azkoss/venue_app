#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import GooglePlaces;
@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSPlacesClient provideAPIKey:@"AIzaSyA3DP6UzDEHtIFsepqZxkd_n4vApRHkqi0"];
  [GMSServices provideAPIKey:@"AIzaSyA3DP6UzDEHtIFsepqZxkd_n4vApRHkqi0"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
