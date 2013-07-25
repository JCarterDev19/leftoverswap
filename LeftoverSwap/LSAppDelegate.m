//
//  LSAppDelegate.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSAppDelegate.h"
#import <Parse/Parse.h>
#import "LSWelcomeViewController.h"

static NSString * const defaultsFilterDistanceKey = @"filterDistance";
static NSString * const defaultsLocationKey = @"currentLocation";
static NSString * const defaultsLastOpenedTimestampKey = @"lastOpenedTimestamp";

@interface LSAppDelegate ()

@property (nonatomic, strong) LSWelcomeViewController *welcomeViewController;

@end

@implementation LSAppDelegate

@synthesize window;

@synthesize navController;
@synthesize welcomeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [Parse setApplicationId:@"rxURqAiZdT4w3QiLPpecMAOyFF2qzVxsLPD1FcGR"
                clientKey:@"HF41j3NxMvnykjW2Cbu7LL48NA2Ebk98qUCT252h"];
  
  // set the global navigation bar tint
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.502 green:1.000 blue:0.000 alpha:1.000]];
  [[UINavigationBar appearance] setTranslucent:YES];
  
  if ([self shouldDisplayWelcomeScreen]) {
    self.welcomeViewController = [[LSWelcomeViewController alloc] init];
  }

  self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
  self.navController.navigationBarHidden = YES;

  self.window.rootViewController = self.navController;

  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  [self.window makeKeyAndVisible];

  return YES;
}
							
#pragma mark - LSAppDelegate

- (BOOL)shouldDisplayWelcomeScreen
{
  BOOL shouldDisplay = NO;
  NSString *lastOpenedTimeKey = @"lastTimeOpened";
  
  NSDate *lastOpened = [[NSUserDefaults standardUserDefaults] objectForKey:lastOpenedTimeKey];
  NSDate *now = [NSDate date];
  if (!lastOpened || [now timeIntervalSinceDate:lastOpened] > 3600) { // 1 hour
    shouldDisplay = YES;
  }
  [[NSUserDefaults standardUserDefaults] setObject:now forKey:lastOpenedTimeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return YES;
}


@end
