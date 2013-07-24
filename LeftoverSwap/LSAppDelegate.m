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

- (BOOL) hasLastOpenedTimerExpired;

@end

@implementation LSAppDelegate

@synthesize filterDistance, currentLocation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [Parse setApplicationId:@"rxURqAiZdT4w3QiLPpecMAOyFF2qzVxsLPD1FcGR"
                clientKey:@"HF41j3NxMvnykjW2Cbu7LL48NA2Ebk98qUCT252h"];
  
  // set the global navigation bar tint
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.502 green:1.000 blue:0.000 alpha:1.000]];
  
  self.filterDistance = 1000 * kLSFeetToMeters;
  
  // Show main screen
  if ([self hasLastOpenedTimerExpired]) {
    [self presentWelcomeViewController];
  } else {
    [NSException raise:@"Not implemented" format:nil];
  }
  
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

  [self.window makeKeyAndVisible];

  return YES;
}
							
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

#pragma mark - LSAppDelegate

- (void)setFilterDistance:(CLLocationAccuracy)aFilterDistance {
  filterDistance = aFilterDistance;
  
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setDouble:filterDistance forKey:defaultsFilterDistanceKey];
	[userDefaults synchronize];
  
	// Notify the app of the filterDistance change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:filterDistance] forKey:kLSFilterDistanceKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kLSFilterDistanceChangeNotification object:nil userInfo:userInfo];
	});
}

- (void)setCurrentLocation:(CLLocation *)aCurrentLocation {
	currentLocation = aCurrentLocation;
  
	// Notify the app of the location change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:currentLocation forKey:kLSLocationKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kLSLocationChangeNotification object:nil userInfo:userInfo];
	});
}

- (void)presentWelcomeViewController {
	// Go to the welcome screen and have them log in or create an account.
	LSWelcomeViewController *welcomeViewController = [[LSWelcomeViewController alloc] initWithNibName:@"LSWelcomeViewController" bundle:nil];
	welcomeViewController.title = @"Welcome to LeftoverSwap";
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
	navController.navigationBarHidden = YES;
  
	self.viewController = navController;
	self.window.rootViewController = self.viewController;
}

- (BOOL)hasLastOpenedTimerExpired
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
  [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:defaultsLastOpenedTimestampKey];
  
  return YES;
}

@end
