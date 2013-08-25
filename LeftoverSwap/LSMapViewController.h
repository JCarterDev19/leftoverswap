//
//  PAWWallViewController.h
//  Anywall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LSLocationController;

@interface LSMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)centerMapOnCurrentLocation;

@end

