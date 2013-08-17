//
//  LSAppDelegate.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSAppDelegate.h"
#import <Parse/Parse.h>
#import "LSWelcomeSigninViewController.h"
#import "LSWelcomeViewController.h"
#import "LSLoginViewController.h"
#import "LSMapViewController.h"
#import "LSCameraPresenterController.h"
#import "LSConversationSummaryViewController.h"

static NSString * const defaultsLastOpenedTimestampKey = @"lastOpenedTimestamp";

@interface LSAppDelegate ()

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) UITabBarController *tabBarController;

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

  [Parse setApplicationId:@"rxURqAiZdT4w3QiLPpecMAOyFF2qzVxsLPD1FcGR"
                clientKey:@"HF41j3NxMvnykjW2Cbu7LL48NA2Ebk98qUCT252h"];
  
  [self setupAppearance];
  
  self.locationController = [[LSLocationController alloc] init];

  self.tabBarController = [[UITabBarController alloc] init];
  
  LSMapViewController *mapViewController = [[LSMapViewController alloc] initWithNibName:nil bundle:nil];
  LSCameraPresenterController *cameraController = [[LSCameraPresenterController alloc] init];
  LSConversationSummaryViewController *conversationController = [[LSConversationSummaryViewController alloc] init];

  self.tabBarController.viewControllers = @[mapViewController, cameraController, conversationController];
  
  self.tabBarController.delegate = self;

//  navController.navigationBarHidden = YES;
  self.viewController = self.tabBarController;
  self.window.rootViewController = self.viewController;

  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

  UIViewController *viewControllerToAppear = nil;
  if (![PFUser currentUser]) {
    
    viewControllerToAppear = [[LSWelcomeSigninViewController alloc] initWithNibName:nil bundle:nil];
    
  } else if ([self shouldDisplayWelcomeScreen]) {
    
    LSWelcomeViewController *welcomeViewController = [[LSWelcomeViewController alloc] init];
    welcomeViewController.delegate = self;
    viewControllerToAppear = welcomeViewController;
    
  }

  [self.window makeKeyAndVisible];
  
  if (viewControllerToAppear) {
    [self.tabBarController presentViewController:viewControllerToAppear animated:NO completion:nil];
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
  if (!lastOpened || [now timeIntervalSinceDate:lastOpened] > 3600) { // 1 hour
    shouldDisplay = YES;
  }
  [[NSUserDefaults standardUserDefaults] setObject:now forKey:lastOpenedTimeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return YES;
}

- (void)setupAppearance {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  
  // set the global navigation bar tint

//  [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.07 green:0.90 blue:0.5 alpha:1.000]];

//  [[UINavigationBar appearance] setTranslucent:YES];

//  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
//  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                        [UIColor whiteColor],UITextAttributeTextColor,
//                                                        [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor,
//                                                        [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],UITextAttributeTextShadowOffset,
//                                                        nil]];

}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController
    shouldSelectViewController:(UIViewController *)aViewController
{
  // Intercept tab event, and trigger its own modal UI instead
  if ([aViewController isKindOfClass:[LSCameraPresenterController class]]) {
    [(LSCameraPresenterController*)aViewController presentCameraPickerController];
    return NO;
  }
  return YES;
}

#pragma mark - LSWelcomeControllerDelegate

-(void)welcomeControllerDidEat:(LSWelcomeViewController *)controller
{
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

-(void)welcomeControllerDidFeed:(LSWelcomeViewController *)controller
{
  [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
