//
//  LSMapViewController.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 8/7/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LSLocationController;

@interface LSMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)centerMapOnCurrentLocation;

@end

