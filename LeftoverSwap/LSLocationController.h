//
//  LSLocationController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** Handles and owns the current location and current filter distance for the application. */
@interface LSLocationController : NSObject <CLLocationManagerDelegate>

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, assign, readonly) CLLocationAccuracy filterDistance;

@end

