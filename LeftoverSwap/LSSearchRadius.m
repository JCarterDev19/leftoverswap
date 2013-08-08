//
//  LSSearchRadius.m
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import "LSSearchRadius.h"

@implementation LSSearchRadius

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate radius:(CLLocationDistance)aRadius {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.radius = aRadius;
	}
	return self;
}

- (MKMapRect)boundingMapRect {
	return MKMapRectWorld;
}

@end
