//
//  LSLocationController.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSLocationController.h"
#import "LSConstants.h"

static double const kLSFeetToMeters = 0.3048; // this is an exact value.
static double const kLSFeetToMiles = 5280.0; // this is an exact value.
static double const kLSMetersInAKilometer = 1000.0; // this is an exact value.

static NSString * const kDefaultsFilterDistanceKey = @"filterDistance";
static NSString * const kDefaultsLocationKey = @"currentLocation";

@interface LSLocationController ()

// CLLocationManagerDelegate methods:
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LSLocationController

@synthesize locationManager;
@synthesize currentLocation;
@synthesize filterDistance;

- (id)init
{
  self = [super init];
  if (self) {
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
    currentLocation = locationManager.location;
    
    // Grab values from NSUserDefaults:
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if ([userDefaults doubleForKey:kDefaultsFilterDistanceKey]) {
      // use the ivar instead of self.accuracy to avoid an unnecessary write to NAND on launch.
      filterDistance = [userDefaults doubleForKey:kDefaultsFilterDistanceKey];
    } else {
      // if we have no accuracy in defaults, set it to 1000 feet.
      filterDistance = 1000 * kLSFeetToMeters;
    }

  }
  return self;
}

- (void)dealloc
{
  [locationManager stopUpdatingLocation];
}

- (void)startUpdatingLocation {
  [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
  [locationManager stopUpdatingLocation];
}

#pragma mark - Custom setters

- (void)setFilterDistance:(CLLocationAccuracy)aFilterDistance {
	filterDistance = aFilterDistance;
  
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setDouble:filterDistance forKey:kDefaultsFilterDistanceKey];
	[userDefaults synchronize];
  
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
    case kCLAuthorizationStatusAuthorized:
      NSLog(@"kCLAuthorizationStatusAuthorized");
      [locationManager startUpdatingLocation];
      break;
    case kCLAuthorizationStatusDenied:
      NSLog(@"kCLAuthorizationStatusDenied");
    {{
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LeftoverSwap can’t access your current location.\n\nTo view nearby posts or create a post at your current location, turn on access for Anywall to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      [alertView show];
    }}
      break;
    default:
      break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Error: %@", [error description]);
  
	if (error.code == kCLErrorDenied) {
		[locationManager stopUpdatingLocation];
	} else if (error.code == kCLErrorLocationUnknown) {
		// todo: retry?
		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
		                                                message:[error description]
		                                               delegate:nil
		                                      cancelButtonTitle:nil
		                                      otherButtonTitles:@"OK", nil];
		[alert show];
	}
}


@end
