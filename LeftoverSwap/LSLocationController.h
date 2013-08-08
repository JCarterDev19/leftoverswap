//
//  LSLocationController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// NSNotification userInfo keys
static NSString * const kLSFilterDistanceKey = @"filterDistance";
static NSString * const kLSLocationKey = @"location";

// NSNotification notifications
static NSString * const kLSFilterDistanceChangeNotification = @"kLSFilterDistanceChangeNotification";
static NSString * const kLSLocationChangeNotification = @"kLSLocationChangeNotification";

/** Handles and owns the current location and current filter distance for the application. */
@interface LSLocationController : NSObject <CLLocationManagerDelegate>

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, assign, readonly) CLLocationAccuracy filterDistance;

@end

