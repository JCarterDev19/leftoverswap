//
//  LSPost.h
//  LeftoverSwap
//
//  Created by Bryan Summersett on 7/24/13.
//  Copyright (c) 2013 LeftoverSwap. All rights reserved.
//

//
//  PAWPost.h
//  Anywall
//
//  Created by Christopher Bowns on 2/8/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "LSPostDetailViewController.h"

extern NSString *const kCantViewPostTitle;

@interface LSPost : NSObject <MKAnnotation>

//@protocol MKAnnotation <NSObject>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// @optional
// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
// @end

@property (nonatomic, readonly) PFFile *thumbnail;

// Other properties:
@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;
@property (nonatomic, readonly, strong) PFUser *user;
@property (nonatomic, assign) BOOL animatesDrop;
@property (nonatomic, readonly) MKPinAnnotationColor pinColor;

- (void)setupAnnotationView:(MKPinAnnotationView*)pinView;
- (UIViewController*)viewControllerWithDelegate:(id<LSPostDetailDelegate>)delegate;

- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToPost:(LSPost *)aPost;

@end
