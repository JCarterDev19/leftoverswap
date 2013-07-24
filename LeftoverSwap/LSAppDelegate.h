//
//  LSAppDelegate.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/23/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

static double const kLSFeetToMeters = 0.3048; // this is an exact value.
static double const kLSFeetToMiles = 5280.0; // this is an exact value.
static double const kLSMetersInAKilometer = 1000.0; // this is an exact value.

// Parse API key constants
static NSString * const kLSParsePostsClassKey = @"Posts";
static NSString * const kLSParseUserKey = @"user";
static NSString * const kLSParseUsernameKey = @"username";
static NSString * const kLSParseTextKey = @"text";
static NSString * const kLSParseLocationKey = @"location";

// NSNotification userInfo keys
static NSString * const kLSFilterDistanceKey = @"filterDistance";
static NSString * const kLSLocationKey = @"location";

// Notification names
static NSString * const kLSFilterDistanceChangeNotification = @"kPAWFilterDistanceChangeNotification";
static NSString * const kLSLocationChangeNotification = @"kPAWLocationChangeNotification";
static NSString * const kLSPostCreatedNotification = @"kPAWPostCreatedNotification";


@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) CLLocationAccuracy filterDistance;
@property (strong, nonatomic) CLLocation *currentLocation;

@end
