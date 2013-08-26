//
//  LSAppDelegate.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSTabBarController.h"
#import <Parse/Parse.h>
#import <HockeySDK/HockeySDK.h>

static NSString * const defaultsLastOpenedTimestampKey = @"lastOpenedTimestamp";

@interface LSAppDelegate ()

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) LSTabBarController *tabBarController;

-(void)setupAppearance;

@end

@implementation LSAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize locationController;
@synthesize tabBarController;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"5626fb490590f2c11ca90eece15c0a23" delegate:self];
  [[BITHockeyManager sharedHockeyManager] startManager];

  [Parse setApplicationId:@"rxURqAiZdT4w3QiLPpecMAOyFF2qzVxsLPD1FcGR"
                clientKey:@"HF41j3NxMvnykjW2Cbu7LL48NA2Ebk98qUCT252h"];
  
  [self setupAppearance];
  
  self.locationController = [[LSLocationController alloc] init];

  self.tabBarController = [[LSTabBarController alloc] init];

  self.viewController = self.tabBarController;
  self.window.rootViewController = self.viewController;

  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  [self.window makeKeyAndVisible];

  if (![PFUser currentUser]) {
    [self.tabBarController presentSignInView];
  } else if ([self shouldDisplayWelcomeScreen]) {
    [self.tabBarController presentWelcomeView];
  }
  
  return YES;
}


#pragma mark - LSAppDelegate

- (BOOL)shouldDisplayWelcomeScreen
{
  BOOL shouldDisplay = NO;
  NSString *lastOpenedTimeKey = @"lastTimeOpened";
  
  NSDate *lastOpened = [[NSUserDefaults standardUserDefaults] objectForKey:lastOpenedTimeKey];
  NSDate *now = [NSDate date];
  if (!lastOpened || [now timeIntervalSinceDate:lastOpened] > 300) { // 5 minutes
    shouldDisplay = YES;
  }
  [[NSUserDefaults standardUserDefaults] setObject:now forKey:lastOpenedTimeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return shouldDisplay;
}

- (void)setupAppearance {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  
  // set the global navigation bar tint

//  [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.411 green:0.858 blue:0.509 alpha:1.000]];
//  [[UINavigationBar appearance] setTranslucent:YES];

//  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
//  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                        [UIColor whiteColor],UITextAttributeTextColor,
//                                                        [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor,
//                                                        [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],UITextAttributeTextShadowOffset,
//                                                        nil]];

}

#pragma mark - BITHockerManagerDelegate

- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifndef CONFIGURATION_AppStore
  if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
    return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
  return nil;
}

@end
